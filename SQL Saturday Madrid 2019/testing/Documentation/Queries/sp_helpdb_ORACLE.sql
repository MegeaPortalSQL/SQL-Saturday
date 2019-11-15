select d.name                                           as "name", 
       to_char(
         (select round(sum(bytes)/1024/1024, 0) 
            from dba_data_files)
         , '999,999') || ' MB'                          as "size",
       (select user from dual)                           as "owner",
        d.dbid                                           as "id",
        to_char(d.created,'DD-MON-YYYY') as "created",
        i.database_status                                as "status",
		'-'											     as "compatibility_level"
  from v$database d, 
       gv$instance i
