# Build Event-driven microservices with Spring Boot and Apache Kafka

## Introduction

This laboratory helps you know how to build an Event-driven architecture based on Spring Boot microservices that “communicate” asynchronously using Apache Kafka. The laboratory have two microservices, a producer and a consumer, built using Spring Boot framework that connect with an Apache Kafka broker to exchange events.

Estimated Time: 10 minutes

### Objectives

- Deploy and access the Kafka Cluster
- Deploy and access the Kafka Producer Microservice
- Deploy and access the Kafka Consumer Microservice
- Learn how they work

### Prerequisites

- *[Optional]* An Oracle Cloud paid account or free trial. To sign up for a trial account with $300 in credits for 30 days, click [Sign Up](http://oracle.com/cloud/free).
- A Docker Engine accessible.

## **Task 1:** Run Kafka Broker and Create a Topic

1. Check the installed Kafka components executing the following command:

    ```bash
    <copy>
    kafka-status
    </copy>
    ```

    As a result, you will see the following components created:

    ```bash
    NAME                COMMAND                  SERVICE             STATUS              PORTS
    broker              "/etc/confluent/dock…"   broker              created
    connect             "/etc/confluent/dock…"   connect             created
    schema-registry     "/etc/confluent/dock…"   schema-registry     created
    zookeeper           "/etc/confluent/dock…"   zookeeper           created
    ```

2. Start the Kafka infrastructure by running the following command:

    ```bash
    <copy>
    kafka-start
    </copy>
    ```

    This command should return the following lines:

    ```bash
    [+] Running 4/4
    ⠿ Container zookeeper        Started                0.6s
    ⠿ Container broker           Started                1.7s
    ⠿ Container schema-registry  Started                3.1s
    ⠿ Container connect          Started                4.4s
    KAFKA_RUNNING completed
    ```

3. Once successfully executed, check that the services are running executing the follwing commands:

    ```bash
    <copy>
    kafka-status
    </copy>
    ```

    First, you will see the four containers running, but the container from Connect Service will be *starting*
    ![Kafka Cluster Services Running with Connect starting](images/kafka-platform-containers-status-starting.png)

    After a few seconds, the container from Connect Service will be *healthy*
    ![Kafka Cluster Services Running with Connect starting](images/kafka-platform-containers-status-healthy.png)

    > **Note:** If your cloud shell connection interrupt during the process, may you will have to reconnect and executing the instructions from [Task 5](#task5restartkafkacomponentsoptional).

4. Create a Topic:

    With the Kafka infrastructure ready, you can create a Kafka Topic which will be used during this workshop. A Kafka Topic is a resource where Events are organized and durable stored. A Topic has a unique name across the entire Kafka cluster and there is not the concept of renaming a Topic thus choose a meaningful name that will categorize well the Events handled by it.

    ```bash
    <copy>
    kafka-add-topic LABTEQTOPIC1
    </copy>
    ```

    This command will create the Kafka Topic and configure the properties of the Producer and Consumer microservices to point to the newly created topic.

    ```bash
    Created topic LABTEQTOPIC1
    Configuring Kafka Producer to produce on topic LABTEQTOPIC1.
    Configuring Kafka Consumer to consume from topic LABTEQTOPIC1.
    ```

## **Task 2:** Build Kafka producer and consumer microservices

This laboratory adopted the microservices architecture and coded the producer and consumer using the Spring Boot framework and Spring Kafka project to connect with Kafka. Maven is the dependency management tool, and to build our code, you have to execute the following commands:

```bash
<copy>
cd $LAB_HOME/springboot-kafka
./kafka-ms-build
</copy>
```

As a result of the Maven build task, you should obtain the following lines showing that both Consumer and Producer were successfully built.

![Spring Boot Apps Build result](images/springboot-kafka-build-result.png " ")

## **Task 3:** Produce events with Kafka producer microservice

1. Deploy Kafka producer microservice

    Now that we have the applications successfully built, we can deploy them and test them. Let's start with the Producer. Run these commands to build the image and deploy the Producer inside the Docker Engine (the same running the Kafka Cluster):

    ```bash
    <copy>
    cd $LAB_HOME/springboot-kafka
    ./kafka-ms-deploy-producer
    </copy>
    ```

    If the deployment task is successful, you will receive the messages below:

    ```bash
    Executing Kafka producer microservice deployment!
    Kafka producer microservices deployment succeeded!
     Step 1/8 : FROM ghcr.io/graalvm/graalvm-ce:ol8-java11 -- Successfully built c2e8cd47b003 Successfully tagged oracle-developers-kafka-producer:0.0.1-SNAPSHOT
    KAFKA_MS_PRODUCER_DEPLOYED completed
    ```

    > **Note:** If the deployment task did not complete correctly, you can investigate the deployment task logs at "$LAB_LOG"/kafka-ms-producer-deployment.log

2. Launch a Kafka producer microservice

    Once you have deployed the producer microservice image, you will be able to launch a container and execute the producer microservice. Issue the follwoing commands:

    ```bash
    <copy>
    cd $LAB_HOME/springboot-kafka
    ./kafka-ms-launch-producer
    </copy>
    ```

    If the deployment task is successful, you will receive the messages "Kafka producer microservice is running!". Yet it is possible to evaluate the logs from the producer issuing the following command to list the late six lines from the container log:

    ```bash
    <copy>container-logs kafka-producer 6</copy>
    ```

    ![Spring Boot Kafka Producer Running Logs](images/springboot-kafka-producer-running.png " ")

3. Test the Kafka producer microservice

    The producer exposes a REST API through which events can be submitted to be handled, that is, in this simple case inserted into Kafka Topic. The producer expects API requests to be in JSON format and to make an API request, for simplicity, we will make a direct HTTP request using cURL tool.

    ```bash
    <copy>
    curl -X POST -H "Content-Type: application/json"  \
         -d '{ "id": "id1", "message": "message1" }'  \
         http://localhost:8080/placeMessage | jq
    </copy>
    ```

    The result should be

    ```bash
    {
        "id": "0",
        "statusMessage": "Successful"
    }
    ```

    <!-- > **Note:** It is possible verify if the message was published inside Kafka Topic submiting the following command:

    ```bash
    <copy>
    kafka-dequeue LABTEQTOPIC1
    </copy>
    ```

    You will need to press Crtl+C to stop this process. The result will be similar to :

    ![Dequeuing Kafka Topic](images/kafka-dequeue.png " ") -->

## **Task 4:** Consume events with Kafka consumer microservice

Now that we have Producer running and publishing events inside the Kafka Broker, you will do the same with Consumer.

1. Deploy Kafka consumer microservice

    We can deploy Consumer microservice running the following commands to build the image and deploy the it inside the Docker Engine (the same running the Kafka Cluster and Producer):

    ```bash
    <copy>
    cd $LAB_HOME/springboot-kafka
    ./kafka-ms-deploy-consumer
    </copy>
    ```

    If the deployment task is successful, you will receive the messages below:

    ```bash
    Executing Kafka consumer microservice deployment!
    Kafka consumer microservices deployment succeeded!
    Successfully built 8cd3a837ad94 Successfully tagged oracle-developers-kafka-consumer:0.0.1-SNAPSHOT grep: /home/paulo_simo/teqodb/microservices-datadriven/work 
    KAFKA_MS_CONSUMER_DEPLOYED completed
    ```

    > **Note:** If the deployment task did not complete correctly, you can investigate the deployment task logs at "$LAB_LOG"/kafka-ms-consumer-deployment.log

2. Launch a Kafka consumer microservice

    Once you have deployed the consumer microservice image, you will be able to launch a container and execute it. Issue the follwoing commands:

    ```bash
    <copy>
    cd $LAB_HOME/springboot-kafka
    ./kafka-ms-launch-consumer
    </copy>
    ```

    If the deployment task is successful, you will receive the messages "Kafka consumer microservice is running!".

    ![Spring Boot Kafka Consumer Running Logs](images/springboot-kafka-consumer-running.png " ")

3. Test the Kafka consumer microservice

    The Consumer microservice after start try to dequeue the messages from the Kafka Broker. If it succeeds in dequeuing the events, we can see in the log the events that were sent by the producer issuing the following command to list the late six lines from the container log:

    ```bash
    <copy>container-logs kafka-consumer 6</copy>
    ```

    The result inside logs of Consumer will be:

    ![Spring Boot Kafka Consumer Running Logs](images/springboot-kafka-consumer-test.png " ")

    With this result, assuming a successful result, we could produce and consume events from Kafka Broker.

## **Task 5:** Restart Kafka Components (optional)

You session of cloud shell may expire or disconnect during the process [bellow image] thus you will have to check if the Kafka components are still running and if not restart them following the next commands:

![Cloud Shell disconnection message](images/cloud-shell-disconnection-message.png " ")

1. Setup environment.

    After reconnect you have to setup environment running the following command:

    ```bash
    <copy>
    source $LAB_HOME/cloud-setup/env.sh
    </copy>
    ```

2. Check if Kafka components are running.

    Execute the following command to check if Kafka Components are running:

    ```bash
    <copy>
    kafka-status
    </copy>
    ```

    You should see the four containers running
    ![Kafka Cluster Services Running with Connect starting](images/kafka-platform-containers-status-healthy.png)

3. Restart components

    If they are not running like bellow image, execute again [Task 1](#task1runkafkabrokerandcreateatopic).

    ![Kafka Cluster Services exist 1](images/kafka-platform-containers-status-exit.png)

You may now **proceed to the next lab**

## Acknowledgements

- **Authors** - Paulo Simoes, Developer Evangelist; Paul Parkinson, Developer Evangelist; Richard Exley, Consulting Member of Technical Staff, Oracle MAA and Exadata
- **Contributors** - Mayank Tayal, Developer Evangelist; Andy Tael, Developer Evangelist; Corrado De Bari, Developer Evangelist; Sanjay Goil, VP Microservices and Oracle Database
- **Last Updated By/Date** - Paulo Simoes, Aug 2022
