create or replace procedure lab_create_user 
(
  pwd in varchar2 default 'Welcome2Movies#'
) as
    user_name varchar2(100);
    kill_session varchar2(200);
begin
    
    user_name := 'MOVIESTREAM';
    
    -- Disconnect all moviestream sessions
    moviestream_write(systimestamp || ' - disconnecting ' || user_name);
    for c in (
    select s.sid,
           s.serial#,
           s.inst_id
    from   gv$session s
    where  s.username = user_name
    )
    loop
        kill_session := 'alter system kill session ''' || c.sid || ',' || c.serial# || ',@' || c.inst_id || '''';
        -- moviestream_write(kill_session);
        execute immediate kill_session;
    end loop;

    begin
        moviestream_write(systimestamp || ' - dropping ' || user_name);
        execute immediate 'drop user moviestream cascade';
    exception
        when others then
            moviestream_write(systimestamp || ' - no user to drop or ' || user_name || ' is connected and could not kill the session');
            moviestream_write(systimestamp || ' - will keep going.');
    end;
    
    begin
        moviestream_write(systimestamp || ' - creating ' || user_name);
        --execute immediate 'create user moviestream identified by ' || pwd;
        execute immediate 'create user moviestream';
    exception
        when others then
            moviestream_write('The ' || user_name || ' user was connected and could not be dropped and recreated.  Make sure the user is logged out.');
            raise;
    end;

    -- Provide minimal tablespace usage.  Uncomment unlimited tablespace use if desired.
    moviestream_write(systimestamp || ' - granting unlimited usage on data tablespace');
    -- execute immediate 'alter user moviestream quota 20G ON data';
    execute immediate 'grant unlimited tablespace to moviestream';

    -- Grant roles/privileges to user
    moviestream_write(systimestamp || ' - granting privileges');
--    execute immediate 'grant connect to ' || user_name;
    execute immediate 'grant dwrole to ' || user_name;
--    execute immediate 'grant resource to ' || user_name;
    execute immediate 'grant oml_developer to ' || user_name;
    execute immediate 'grant graph_developer to ' || user_name;
    execute immediate 'grant console_developer to ' || user_name;
    execute immediate 'grant dcat_sync to ' || user_name;
  
    -- These grants are required in order to make plsql automation to work
    execute immediate 'grant select on v$services to ' || user_name;
    execute immediate 'grant select on dba_rsrc_consumer_group_privs to  ' || user_name;
    execute immediate 'grant execute on dbms_session to  ' || user_name;
    execute immediate 'grant execute on dbms_cloud to  ' || user_name;
    execute immediate 'grant read,write on directory data_pump_dir to ' || user_name;
    execute immediate 'grant ALTER  SESSION,
                                    CONNECT,
                                    RESOURCE,
                                    CREATE ANALYTIC VIEW,
                                    CREATE ATTRIBUTE DIMENSION,
                                    CREATE HIERARCHY,
                                    CREATE JOB,
                                    CREATE MATERIALIZED VIEW,
                                    CREATE MINING MODEL,
                                    CREATE PROCEDURE,
                                    CREATE SEQUENCE,
                                    CREATE SESSION,
                                    CREATE SYNONYM,
                                    CREATE TABLE,
                                    CREATE TRIGGER,
                                    CREATE TYPE,
                                    CREATE VIEW to '|| user_name;
    execute immediate 'grant inherit privileges on user admin to ' || user_name;
    execute immediate 'alter user ' || user_name || ' grant connect through OML$PROXY';
    execute immediate 'alter user ' || user_name || ' grant connect through GRAPH$PROXY_USER';
    
    moviestream_write(systimestamp || ' - enabling SQL tools access');
    ords.enable_schema (
        p_enabled               => TRUE,
        p_schema                => 'moviestream',
        p_url_mapping_type      => 'BASE_PATH',
        p_auto_rest_auth        => TRUE   
    );
    commit;
    
    -- Message about password
    moviestream_write('');
    moviestream_write('You can not log in until you set a password!');
    moviestream_write('');
    moviestream_write('Please create a secure password using the following command:');
    moviestream_write('  ALTER USER moviestream IDENTIFIED BY "<secure password>";');
    moviestream_write('');
    
exception
    when others then
        moviestream_write('ERROR.');
        moviestream_write(sqlerrm);


end lab_create_user;