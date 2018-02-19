OPTIONS (ROWS=5000, PARALLEL=false, BINDSIZE=20000000, READSIZE=20000000)
LOAD DATA
CHARACTERSET 'WE8ISO8859P15'
INFILE 'E:/Talend trunk client/Talend_TOS_trunk/tuj/java/bug7782_tOracleBulkExec/output.csv'
BADFILE 'E:/Talend trunk client/Talend_TOS_trunk/tuj/java/bug7782_tOracleBulkExec/output.csv.bad'
DISCARDFILE 'E:/Talend trunk client/Talend_TOS_trunk/tuj/java/bug7782_tOracleBulkExec/output.csv.dsc'
INTO TABLE tmp_tOracleBulkExec_1_MJqIxw
INSERT
FIELDS TERMINATED BY ";"
("ID_ALLOCATAIRE", 
"NUM_DEMANDE", 
"FLAG_NV_ENTRANT")
