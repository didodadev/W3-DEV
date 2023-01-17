<cfcomponent displayname="" output="false">
    <cffunction name="get_policy_period" access="public" returntype="query"> 
        <cfscript>    
            policy_periods = queryNew("value,name", "varchar,varchar",
                [ 
                    {value=1,name="6 Ayda"}, 
                    {value=2,name="1 Yıl"}, 
                    {value=3,name="2 Yıl"}
                ]); 
            return policy_periods;
        </cfscript>
    </cffunction>
    <cffunction name="get_status" access="public" returntype="array"> 
        <cfargument name="is_form" type="boolean" default="False">
        <cfscript>
            status = ArrayNew(1);
            if(is_form){
                status =[
                    {value="1",name="Aktif"}, 
                    {value="0",name="Pasif"}
                ]; 
            }else{
                status =[
                    {value="",name="Tümü"},
                    {value="1",name="Aktif"}, 
                    {value="0",name="Pasif"}
                ]; 
            }
        return status;
        </cfscript>
    </cffunction>
    <cffunction name="get_transfer_value" access="public" returntype="array"> 
        <cfscript>    
            type = ArrayNew(1);
            type = [ 
                    {value="1",name="Aktarılıyor"}, 
                    {value="0",name="Aktarılmıyor"}
                ]; 
            return type;
        </cfscript>
    </cffunction>
    <cffunction name="get_storage_types" access="public" returntype="array"> 
        <cfscript>
            type = ArrayNew(1);
            type = 
                [ 
                    {value="1",name="Dijital"}, 
                    {value="2",name="Basılı Evrak"},
                    {value="3",name="Fiziksel Ortam"},
                    {value="4",name="Elektronik Dosya"}
                ]; 
            return type;
        </cfscript>
    </cffunction>
    <cffunction name="get_keyword_types" access="public" returntype="array"> 
        <cfscript>    
            type = ArrayNew(1);
            type = [ 
                    {value="0",name="All"},
                    {value="1",name="Database"}, 
                    {value="2",name="File"}
                ]; 
            return type;
        </cfscript>
    </cffunction>
    <cffunction name="get_keyword_search_types" access="public" returntype="array"> 
        <cfscript>    
            type = ArrayNew(1);
            type = [
                    {value="0",name="Exclude"},
                    {value="1",name="Equal"},
                    {value="2",name="Contains"}
                   
                ]; 
            return type;
        </cfscript>
    </cffunction>
    <cffunction name="get_classification_types" access="public" returntype="array"> 
        <cfscript>    
            type = ArrayNew(1);
            type = [ 
                    {value="1",name="Database"},
                    {value="2",name="File"},
                    {value="3",name="Other"}
                ]; 
            return type;
        </cfscript>
    </cffunction>
    <cffunction name="get_data_precaution_type" access="public" returntype="array"> 
        <cfscript>    
            type = ArrayNew(1);
            type = [ 
                    {value="1",name="İdari"},
                    {value="2",name="Teknik"}
                ]; 
            return type;
        </cfscript>
    </cffunction>
</cfcomponent>
