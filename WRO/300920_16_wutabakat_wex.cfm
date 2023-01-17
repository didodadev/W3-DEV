<!-- Description : Mutabakat modülü
Developer: Halit Yurttaş
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT 'Y' FROM WRK_WEX WHERE HEAD = 'wutabakat')
    BEGIN
        INSERT INTO [WRK_WEX]([IS_ACTIVE],[MODULE],[HEAD],[DICTIONARY_ID],[VERSION],[TYPE],[LICENCE],[REST_NAME],[TIME_PLAN_TYPE],[TIME_PLAN],[AUTHENTICATION],[STATUS],[STAGE],[AUTHOR],[FILE_PATH],[RECORD_IP],[RECORD_EMP],[RECORD_DATE],[UPDATE_IP],[UPDATE_EMP],[UPDATE_DATE],[RELATED_WO],[IMAGE],[DETAIL],[SOURCE_WO],[WEX_FILE_ID]) Values( '1','23','Mutabakat','31568','1','2','1','wutabakat','1',Null,'1','Deployment','70','Halit Yurttaş','WEX/wutabakat/hooks/endpoint.cfm','185.219.179.71','67','Sep  9 2020  4:21PM','185.219.179.71','67','Sep  9 2020  5:10PM','','','','',Null)
    END;
</querytag>