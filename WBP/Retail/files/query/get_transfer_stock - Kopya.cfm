<cfparam name="attributes.type" default="v">
<cfoutput>
	<script>
    function delete_row_#attributes.DEPARTMENT_ID#()
    {
        AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_transfer_stock&type=d&department_id=#attributes.DEPARTMENT_ID#&stock_id=#attributes.stock_id#','dagitim_#attributes.DEPARTMENT_ID#_#attributes.stock_id#');
    }
    
    function add_row_#attributes.DEPARTMENT_ID#()
    {
        AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_transfer_stock&type=a&department_id=#attributes.DEPARTMENT_ID#&stock_id=#attributes.stock_id#','dagitim_#attributes.DEPARTMENT_ID#_#attributes.stock_id#');
    }
    
    function get_row_#attributes.DEPARTMENT_ID#()
    {
        AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_transfer_stock&type=v&department_id=#attributes.DEPARTMENT_ID#&stock_id=#attributes.stock_id#','dagitim_#attributes.DEPARTMENT_ID#_#attributes.stock_id#');
    }
    </script>
	<cfif attributes.type is 'v'>
        <cfquery name="get_" datasource="#dsn_Dev#">
            SELECT
                STOCK_ID,
                DEPARTMENT_ID
            FROM
                STOCK_TRANSFER_LIST
            WHERE
                STOCK_ID = #attributes.stock_id# AND
                DEPARTMENT_ID = #attributes.department_id#
        </cfquery>
        <cfif get_.recordcount>
            <a href="javascript://" onclick="del_row_#attributes.DEPARTMENT_ID#();"><img src="/images/delete_list.gif" /></a>
        <cfelse>
            <a href="javascript://" onclick="add_row_#attributes.DEPARTMENT_ID#();"><img src="/images/plus_list.gif" /></a>
        </cfif>
    <cfelseif attributes.type is 'a'>
        <cfquery name="add_" datasource="#dsn_dev#">
            INSERT INTO
                STOCK_TRANSFER_LIST
                (
                STOCK_ID,
                DEPARTMENT_ID,
                RECORD_EMP,
                RECORD_DATE
                )
                VALUES
                (
                #attributes.stock_id#,
                #attributes.department_id#,
                #session.ep.userid#,
                #now()#
                )
        </cfquery>
        <script>
            get_row_#attributes.DEPARTMENT_ID#();
        </script>
    <cfelseif attributes.type is 'd'>
        <cfquery name="add_" datasource="#dsn_dev#">
            DELETE FROM
                STOCK_TRANSFER_LIST
            WHERE
                STOCK_ID = #attributes.stock_id# AND
                DEPARTMENT_ID = #attributes.department_id#
        </cfquery>
        <script>
            get_row_#attributes.DEPARTMENT_ID#();
        </script>
    </cfif>
</cfoutput>