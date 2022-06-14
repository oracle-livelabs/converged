create or replace procedure run_lab_prereq 
(
  lab_number in number default null 
) as 
    lab_found boolean := false;
    e_no_lab_number EXCEPTION;
    PRAGMA exception_init( e_no_lab_number, -20001 );
    e_table_exists exception;
    PRAGMA exception_init( e_table_exists, -955 );
    
begin
  
    begin
        -- Create a logging table
        execute immediate 'create table moviestream_log (execution_time timestamp, message varchar2(1000))';
        execute immediate 'create or replace public synonym moviestream_log for admin.moviestream_log';
        execute immediate 'create or replace public synonym moviestream_write for admin.moviestream_write';
        execute immediate 'grant execute on admin.moviestream_write to public';
    exception 
        when e_table_exists then
            null;
        when others then
            moviestream_write(sqlerrm);
            raise;
    end;
            
    -- Clear logging table
    execute immediate 'truncate table moviestream_log';
    
    if lab_number < 4 or lab_number is null then 
        moviestream_write('');
        moviestream_write('Invalid lab number was specified.  Please specify the number of the lab.');
        moviestream_write('Valid values are greater than 4. The earlier labs do not have prerequistes.');
        moviestream_write('');
        moviestream_write('For example, to run all the prerequisites for Lab 4:');
        moviestream_write('');
        moviestream_write('  exec run_lab_prereq(lab_number => 4)');
        
        raise e_no_lab_number;

    end if;
        
      moviestream_write(''); 
      moviestream_write('Finding prequisites for lab #' || lab_number);
      -- Get the list of prequisite labs
      -- Those will be lab numbers that come before the user provided lab
      for lab_rec in (
            select  json_value (doc, '$.lab_num' returning number) lab_num,
                    json_value (doc, '$.title' returning varchar2(500)) title,
                    json_value (doc, '$.script' returning varchar2(100)) script        
            from moviestream_labs ml
            where json_value (doc, '$.script' returning varchar2(100))  is not null
              and json_value (doc, '$.lab_num' returning number) > 0  -- "negative" labs are infrastructure
              and json_value (doc, '$.lab_num' returning number) < lab_number -- prerequiste labs
            order by 1 asc
            )       
        loop
        -- Run the prerequisite script
        lab_found := true;
        moviestream_write('  ********');
        moviestream_write('  ** Running script for ' || lab_rec.title);   
        moviestream_write('  ** Script name: ' || lab_rec.script);   
        moviestream_write('  ********');
        execute immediate ('begin ' || lab_rec.script || '; end;');

    end loop lab_rec; 

    
    moviestream_write('Done.');
    moviestream_write('');
    if lab_number >= 4  then
        moviestream_write('');
        moviestream_write('Don''t forget to set a password for the moviestream user!');
        moviestream_write('');
        moviestream_write('Please create a secure password using the following command:');
        moviestream_write('');
        moviestream_write('  ALTER USER moviestream IDENTIFIED BY "<secure password>";');
        moviestream_write('');
    end if;
    
exception
    when others then        
        moviestream_write('');
        moviestream_write('* ERROR * ' || sqlerrm);
        
end run_lab_prereq;