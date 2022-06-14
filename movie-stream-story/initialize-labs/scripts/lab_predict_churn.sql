create or replace procedure lab_predict_churn as 
begin
    moviestream_write(systimestamp || ' - import potential churn customers');        
    execute immediate 'create table moviestream.potential_churners as select * from moviestream.ext_potential_churners';
end lab_predict_churn;