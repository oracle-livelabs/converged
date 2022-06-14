create or replace procedure moviestream_write 
(
  message in varchar2 default ''
) as 
begin
    dbms_output.put_line(to_char(systimestamp, 'DD-MON-YY HH:MI:SS') || ' - ' || message); 

    if message is not null then
        execute immediate 'insert into moviestream_log values(:t1, :msg)' 
                using to_char(systimestamp, 'DD-MON-YY HH:MI:SS'), message;
        commit;
    end if;

end moviestream_write;