# Additional Features

## Introduction

In this lab, we'll use the Transactional Event Queues PL/SQL API to explore additional messaging features like expiry, delay, and priority. 

Estimated Time: 5 minutes

### Objectives

Familiarity with additional features of Transactional Event Queues' PL/SQL API, including:

- Message Expiry and Exception Queues
- Message Delay
- Message Priority

### Prerequisites

This lab assumes you have:

- A Free Tier, Paid or LiveLabs Oracle Cloud account
- You have completed the introduction and lab setup

## **Task 1:** Send an expired message to an exception queue

When enqueuing a message, an expiry time may be specified using the expiration attribute of the [message_properties object](https://docs.oracle.com/en/database/oracle/oracle-database/23/arpls/advanced-queuing-AQ-types.html#GUID-7232160F-22CF-4DF7-BAAF-96EDCC5CB452).

Configuring a message's expiring sets the number of seconds for which a message is may be dequeued. Messages older than their expiration time are automatically moved to an **exception queue**. The exception queue contains any expired or failed messages, and uses the same backing database table as the main queue.

The following SQL statement creates a queue named `lab_queue`, and an association exception queue named `lab_queue_eq`. Any expired or failed messages enqueued to the `lab_queue` queue will be moved to the `lab_queue_eq` queue. Run this statement to create the queue and exception queue:

```sql
begin
    dbms_aqadm.create_transactional_event_queue(
            queue_name         => 'lab_queue'
    );
    dbms_aqadm.start_queue(
            queue_name         => 'lab_queue'
    );
    dbms_aqadm.create_eq_exception_queue(
        queue_name => 'lab_queue',
        exception_queue_name => 'lab_queue_eq'
    );
end;
```

Next, enqueue a message to the queue with a 5-second expiration:

```sql
declare
    enqueue_options dbms_aq.enqueue_options_t;
    message_properties dbms_aq.message_properties_t;
    message_handle raw(16);
    message sys.aq$_jms_text_message;
begin
    message := sys.aq$_jms_text_message.construct();
    message.set_text('this is my message');

    message_properties.expiration := 5; -- message expires in 5 seconds
    dbms_aq.enqueue(
        queue_name => 'lab_queue',
        enqueue_options => enqueue_options,
        message_properties => message_properties,
        payload => message,
        msgid => message_handle
    );
    commit;
end;
/
```

After the enqueue, wait at least 5 seconds and query the messages in the exception queue. The expired message should be present in the exception queue:

```sql
-- The exception queue uses the same backing table as the main queue
select * from lab_queue
where expiration < systimestamp - interval '5' second;
```

## **Task 2:** Enqueue a message with delay

When enqueuing a message, you can specify a delay (in seconds) before the message becomes available for dequeue. Message delay allows you to schedule messages to be available for consumers after a specified time, and is configured using the delay attribute of the message_properties object.

The following SQL statement enqueues a message with a 7-day delay, meaning it will not be available to consumers until 7 days have passed.

```sql
declare
    enqueue_options dbms_aq.enqueue_options_t;
    message_properties dbms_aq.message_properties_t;
    message_handle raw(16);
    message sys.aq$_jms_text_message;
begin
    message := sys.aq$_jms_text_message.construct();
    message.set_text('this is my message');

    message_properties.delay := 7*24*60*60; -- Delay for 7 days
    dbms_aq.enqueue(
        queue_name => 'lab_queue',
        enqueue_options => enqueue_options,
        message_properties => message_properties,
        payload => message,
        msgid => message_handle
    );
    commit;
end;
/
```

When delayed messages the `DELIVERY_TIME` column is configured with the date the message is available for consumers. The following SQL statement queries the previously enqueued message, showing the delivery time.

```sql
select msgid, delivery_time from lab_queue
where delivery_time is not null;
```

Because the message is delayed, a dequeue will result in the `ORA-25228: timeout or end-of-fetch during message dequeue from <SCHEMA>.<QUEUE NAME>` error. The following SQL statement attempts a dequeue, and then encounters this error if no other messages are present in the queue:

```sql
declare
    dequeue_options dbms_aq.dequeue_options_t;
    message_properties dbms_aq.message_properties_t;
    msg_id raw(16);
    message sys.aq$_jms_text_message;
begin
    dequeue_options.navigation := dbms_aq.first_message;
    dequeue_options.wait := dbms_aq.no_wait;
    
    dbms_aq.dequeue(
        queue_name => 'lab_queue',
        dequeue_options => dequeue_options,
        message_properties => message_properties,
        payload => message,
        msgid => msg_id
    );
    commit;
exception
    when others then
        dbms_output.put_line('failed to dequeue message: ' || sqlerrm);
end;
```

## **Task 3:** Enqueue a message with priority

When enqueuing a message, you can specify its priority using the priority attribute of the message_properties object. This attribute allows you to control the order in which messages are dequeued. The lower a message’s priority number, the higher the message’s precedence for consumers.

When enqueuing prioritized messages, the `PRIORITY`
column in the queue table will be populated with the priority number.

```sql
declare
    enqueue_options dbms_aq.enqueue_options_t;
    message_properties dbms_aq.message_properties_t;
    message_handle raw(16);
    message sys.aq$_jms_text_message;
begin
    message := sys.aq$_jms_text_message.construct();
    message.set_text('this is my message');

    message_properties.priority := 1; -- A lower number indicates higher priority
    dbms_aq.enqueue(
        queue_name => 'lab_queue',
        enqueue_options => enqueue_options,
        message_properties => message_properties,
        payload => message,
        msgid => message_handle
    );
    commit;
end;
/
```

Messages may also be queried by their priority. The following SQL statement retrieves any messages with `priority = 1`:

```sql
select msgid, enqueue_time, priority from lab_queue
where priority = 1;
```

You may now **proceed to the next lab**

## Acknowledgements

- **Authors** - Anders Swanson, Developer Evangelist;
- **Contributors** - Anders Swanson, Developer Evangelist;
- **Last Updated By/Date** - Anders Swanson, Feb 2024
