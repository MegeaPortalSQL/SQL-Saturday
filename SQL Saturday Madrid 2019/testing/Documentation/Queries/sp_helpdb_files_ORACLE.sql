select
d.TABLESPACE_NAME as "name",
d.FILE_ID as "id",
d.FILE_NAME as "filename",
' - '  as "filegroup",
to_char(d.USER_BYTES/1024/1024,'999,99') || ' MB' as "size",
to_char(d.MAXBYTES/1024/1024,'999,99') || ' MB' as "max_bytes",
to_char(d.INCREMENT_BY* t.BLOCK_SIZE/1024/1024,'999,99') || ' MB'  as "growth"
from dba_data_files d
INNER JOIN DBA_TABLESPACES t  on t.TABLESPACE_NAME =d.TABLESPACE_NAME
order by d.TABLESPACE_NAME