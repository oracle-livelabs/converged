# Additional Features

## Introduction

TBD

Estimated Time: 5 minutes

### Objectives

- TBD

### Prerequisites

- TBD

## **Task 1:** TBD

```sql
begin
    dbms_aqadm.stop_queue(
        queue_name => 'json_queue'
    );
    dbms_aqadm.drop_transactional_event_queue(
        queue_name => 'json_queue'
    );
end;
/
```

You may now **proceed to the next lab**

## Acknowledgements

- **Authors** - Anders Swanson, Developer Evangelist;
- **Contributors** - 
- **Last Updated By/Date** - Anders Swanson, Feb 2024
