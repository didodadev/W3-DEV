<cfsetting showdebugoutput="no">
<!--- Fatih Ayık
        wrk_query fonksiyonundan gelen sorgular * ile cekilemez.
        UPDATE,DELETE,INSERT,DROP,ALTER,TRUNCATE,CREATE,CHAR,TABLE,DATABASE,COLUMN,DECLARE,EXEC islemlerini yapamaz
        EMPLOYEES,EMPLOYEE_SALARY,EMPLOYEES_PUNATAJ_ROWS,WRK_MESSAGE vs sifre ve özel bilgilerin tutulduğu tablolardan wrk_query ile sorgu yapılamaması gerekir.
    
        db, ifadesini kaldirdim fbs20121214 wrk_row_idlerde iki harf yanyana denk geldiginde query calismiyor, db kelimesi direkt engellenmeli mi?
		
		sadece Employee portalden bu şekilde sorgu çekilebilir
    --->
<cfif isdefined('session.ep')>
	<cfif not len(cgi.referer)>
    	<script language="javascript">
			var get_js_query=new Object();
			get_js_query.recordcount = 0;
		</script>
        <cfexit method="exittemplate">
    </cfif>
    
    <cfset reserved_words = 'shutdown,@@,sp_tables,sp_,update,delete,insert,drop,alter,truncate,create,char,table,database,column,declare,exec,select *,EMPLOYEES,EMPLOYEE_SALARY,EMPLOYEES_PUANTAJ_ROWS,WRK_MESSAGE'>
    
    <cfset this_str_ = '#form.str_sql#'>
    <cfset this_str_ = replacelist(this_str_,'dbo,UPDATE_,_TABLE,TABLE_','-,-,-,-')>
    <cfset error_count_ = 0>
    <cfloop from ="1" to="#listlen(this_str_,',')#" index='j'>
        <cfloop from='1' to="#listlen(reserved_words,',')#" index='i'>
            <cfif '#ListGetAt(this_str_,j," ")#' is '#ListGetAt(reserved_words,i,',')#' or '#ListGetAt(this_str_,j," ")#' is '#ucase(ListGetAt(reserved_words,i,','))#'>
                <cfset error_count_ = 1>
                <cfif error_count_ eq 1>
                    <script language="javascript">
                        var get_js_query=new Object();
                        get_js_query.recordcount = 0;
                        alert('İzin Verilmeyen İşlem Yaptınız!');
                    </script>                  
                    <cfexit method="exittemplate">
                </cfif>
            </cfif>
        </cfloop>
	</cfloop>
	<cfif isdefined('attributes.data_source')><!---20141222  GA Form yazımı hataya sebep olduğu için attributes ile revize edildi.--->
        <cfset 'form.#data_source#' = attributes.data_source>
    <cfelse>
        <cfset 'form.#data_source#' = 'dsn'>	
    </cfif>
    <!---<cfif not isdefined('#form.data_source#')><!---20081013 FA istenilen datasoruce tanımlı değil ise yollanan ifade datasoruce olarak kullanılıyor --->
        <cfset 'form.#data_source#' = form.data_source>
    </cfif>--->
    <cfif isDefined('form.str_sql') and len(form.str_sql) and (not form.str_sql contains 'DELETE FROM ')>
        <cfif isDefined('form.maxrows') and len(form.maxrows) and form.maxrows gt 0>
            <cfquery name="get_js_query" datasource="#evaluate('#form.data_source#')#" maxrows="#form.maxrows#">
                <cfoutput>#PreserveSingleQuotes(form.str_sql)#</cfoutput>
            </cfquery>
        <cfelse>
            <cftry>
                <cfquery name="get_js_query" datasource="#evaluate('#form.data_source#')#">
                    <cfoutput>#PreserveSingleQuotes(form.str_sql)#</cfoutput>
                </cfquery>
                <cfcatch type="any">
                    <cfset get_js_query.recordcount = 0>
                </cfcatch>
            </cftry>
        </cfif>
        <cfif not isdefined('get_js_query.recordcount')>
            <cfset get_js_query.recordcount = 0>
        </cfif>
    <cfelse>
        <cfset get_js_query.recordcount = 0>
    </cfif>
    var get_js_query=new Object();
    get_js_query.recordcount=<cfoutput>#get_js_query.recordcount#</cfoutput>;
    <cfif get_js_query.recordcount>
        get_js_query.columnList='<cfoutput>#get_js_query.columnList#</cfoutput>';
        <cfloop list="#get_js_query.columnList#" index="i_AJAX">
            get_js_query.<cfoutput>#i_AJAX#</cfoutput>=new Array(1);
            <cfoutput query="get_js_query">
                get_js_query.#i_AJAX#[#get_js_query.currentrow-1#] = "#evaluate('get_js_query.#i_AJAX#[#get_js_query.currentrow#]')#";
          </cfoutput>
        </cfloop>
    </cfif>
<cfelse>
    alert('İzin Verilmeyen İşlem Yaptınız!');
    <cfexit method="exittemplate">
</cfif>
