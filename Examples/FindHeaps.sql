-- Look for heaps in database and then add the IDENTITY() column and INDEX on that

select 
 [Database Name] = db_name()
, [Table Name] = s.name + '.' + o.name
, p.row_count
, SizeMb= (p.reserved_page_count*8.)/1024.
from 
 sys.objects o
inner join  sys.schemas s on o.schema_id = s.schema_id
inner join  sys.dm_db_partition_stats p  on p.object_id = o.object_id 
inner join  sys.indexes si on si.object_id = o.object_ID
WHERE si.type_desc = 'Heap'
and  is_ms_shipped = 0
order by SizeMb desc
