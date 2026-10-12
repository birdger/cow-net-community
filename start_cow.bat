@echo off
REM ============================================================
REM  仿牛客网讨论社区 - 一键启动脚本
REM  依赖: MySQL 服务(MySQL57/MySQL80) 需已运行
REM  端口: 应用 8081 (8080 被其他项目占用时)
REM  环境: F:\Environment (JDK8 / Redis / ES 6.8 / Kafka)
REM ============================================================
set "JAVA_HOME=F:\Environment\jdk1.8.0_131"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo [1/5] 启动 Redis (6379) ...
start "cow-redis" /min "F:\Environment\Redis-x64-5.0.14.1\redis-server.exe" --port 6379 --protected-mode no

echo [2/5] 启动 Elasticsearch 6.8.23 (9200/9300, cluster=nowcoder) ...
start "cow-es" /min cmd /c "cd /d F:\Environment\elasticsearch-6.8.23 && call bin\elasticsearch.bat -Ecluster.name=nowcoder"

echo [3/5] 启动 Zookeeper (2181) ...
start "cow-zk" /min cmd /c "cd /d F:\Environment\kafka_2.12-2.8.2 && call bin\windows\zookeeper-server-start.bat config\zookeeper.properties"
timeout /t 15 /nobreak >nul

echo [4/5] 启动 Kafka broker (9092) ...
start "cow-kafka" /min cmd /c "cd /d F:\Environment\kafka_2.12-2.8.2 && call bin\windows\kafka-server-start.bat config\server.properties"
timeout /t 25 /nobreak >nul

echo [5/5] 启动应用 -> http://localhost:8081
cd /d G:\Project_Files\2_Institution-project\error\Cow-net-master\community\target
java -Xmx512m -jar ROOT.war --spring.profiles.active=develop --server.port=8081