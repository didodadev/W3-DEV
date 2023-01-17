<cfcomponent>
	<cfsetting requesttimeout="2000">
    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- Bu fonksiyon kendisine gelen sayı formatını dilin binlik ve ondalık karakterine göre string'e dönüştürür --->
    <cffunction name="AmountFormat" returntype="string" output="false">
        <cfargument name="money" required="true"><!---  type="numeric" --->
        <cfargument name="no_of_decimal" type="numeric" required="no" default="2">
        <cfscript>
        if (not len(arguments.money)) return 0;
        if (arguments.money contains 'E') arguments.money = ReplaceNoCase(DecimalFormat(arguments.money), ',', '', 'all');
        if (arguments.money contains '-'){
            negativeFlag = 1;
            arguments.money = ReplaceNoCase(arguments.money, '-', '', 'all');}
        else negativeFlag = 0;
        if(not isnumeric(arguments.no_of_decimal)) arguments.no_of_decimal= 2;	
        nokta = Find('.', arguments.money);
        if (nokta){
            tam = Mid(arguments.money, 1, nokta-1);
            onda = Mid(arguments.money, nokta+1,arguments.no_of_decimal);}
        else{
            tam = arguments.money;
            onda = RepeatString(0,arguments.no_of_decimal);}
        textFormat='';
        t=0;
        if (len(tam) gt 3) 
            {
            for (k=len(tam); k; k=k-1){
                t = t+1;
                if (not (t mod 3)) textFormat = '.' & mid(tam, k, 1) & textFormat; 
                else textFormat = mid(tam, k, 1) & textFormat;} 
            if (mid(textFormat, 1, 1) is '.') textFormat =  "#right(textFormat,len(textFormat)-1)#,#onda#";
            else textFormat =  "#textFormat#,#onda#";
            }
        else textFormat = "#tam#,#onda#";
        if (negativeFlag) textFormat =  "-#textFormat#";
        
        //Bu kosul yabanci dildeki nokta, virgul sorunu icin eklenmistir
        if(isdefined("moneyformat_style") and moneyformat_style eq 1)
            {
                textFormat = replace(textFormat,'.','*','all');
                textFormat = replace(textFormat,',','.','all');
                textFormat = replace(textFormat,'*',',','all');
                
                if (not arguments.no_of_decimal) 
                    return ListFirst(textFormat,'.');
                else 
                    return textFormat;
            }
        else
            {
            if (not arguments.no_of_decimal) 
                return ListFirst(textFormat,',');
            else 
                return textFormat;
            }
        </cfscript>
    </cffunction>
    
    <!--- Bu fonksiyon yuvarlama işlemi yapar. --->
    <cffunction name="wrk_round" returntype="string" output="false">
        <cfargument name="number" required="true">
        <cfargument name="decimal_count" required="no" default="2">
        <cfargument name="kontrol_float" required="no" default="0"><!--- ürün ağacında çok ufak değerler girildiğinde E- formatında yazılanlar bozulmasın diye eklendi SM20101007 --->
        <cfscript>
            if (not len(arguments.number)) return '';
            if(arguments.kontrol_float eq 0)
            {
                if (arguments.number contains 'E') arguments.number = ReplaceNoCase(NumberFormat(arguments.number), ',', '', 'all');
            }
            else
            {
                if (arguments.number contains 'E') 
                {
                    first_value = listgetat(arguments.number,1,'E-');
                    first_value = ReplaceNoCase(first_value,',','.');
                    last_value = ReplaceNoCase(listgetat(arguments.number,2,'E-'),'0','','all');
                    //if(last_value gt 5) last_value = 5;
                    for(kk_float=1;kk_float lte last_value;kk_float=kk_float+1)
                    {
                        zero_info = ReplaceNoCase(first_value,'.','');
                        first_value = '0.#zero_info#';
                    }
                    arguments.number = first_value;
                            first_value = listgetat(arguments.number,1,'.');
                arguments.number = "#first_value#.#Left(listgetat(arguments.number,2,'.'),8)#";
                    if(arguments.number lt 0.00000001) arguments.number = 0;
                    return arguments.number;
                }
            }
            if (arguments.number contains '-'){
                negativeFlag = 1;
                arguments.number = ReplaceNoCase(arguments.number, '-', '', 'all');}
            else negativeFlag = 0;
            if(not isnumeric(arguments.decimal_count)) arguments.decimal_count= 2;	
            if(Find('.', arguments.number))
            {
                tam = listfirst(arguments.number,'.');
                onda =listlast(arguments.number,'.');
                if(onda neq 0 and arguments.decimal_count eq 0) //yuvarlama sayısı sıfırsa noktadan sonraki ilk rakama gore tam kısımda yuvarlama yapılır
                {
                    if(Mid(onda, 1,1) gte 5) // yuvarlama 
                        tam= tam+1;	
                }
                else if(onda neq 0 and len(onda) gt arguments.decimal_count)
                {
                    if(Mid(onda,arguments.decimal_count+1,1) gte 5) // yuvarlama
                    {
                        onda = Mid(onda,1,arguments.decimal_count);
                        textFormat_new = "0.#onda#";
                        textFormat_new = textFormat_new+1/(10^arguments.decimal_count);
                        
                        decimal_place_holder = '_.';
                        for(decimal_index=1;decimal_index<=arguments.decimal_count;++decimal_index)
                            decimal_place_holder = '#decimal_place_holder#_';
                        textFormat_new = LSNumberFormat(textFormat_new,decimal_place_holder);
                            
                        if(listlen(textFormat_new,'.') eq 2)
                        {
                            tam = tam + listfirst(textFormat_new,'.');
                            onda =listlast(textFormat_new,'.');
                        }
                        else
                        {
                            tam = tam + listfirst(textFormat_new,'.');
                            onda = '';
                        }
                    }
                    else
                        onda= Mid(onda,1,arguments.decimal_count);
                }
            }
            else
            {
                tam = arguments.number;
                onda = '';
            }
            textFormat='';
            if(len(onda) and onda neq 0 and arguments.decimal_count neq 0)
                textFormat = "#tam#.#onda#";
            else
                textFormat = "#tam#";
            if (negativeFlag) textFormat =  "-#textFormat#";
            return textFormat;
        </cfscript>
    </cffunction>

	<!--- Amount format gibi çalışır. Fakat binlik ayraç sabit (.) iken ondalık ayraç (,) dır --->
    <cffunction name="TLFormat" returntype="string" output="false">
        <!--- <cfargument name="money" type="numeric" required="true"> sorunlar duzelince alttaki yerine acilacak--->
        <cfargument name="money">
        <cfargument name="no_of_decimal" required="no" default="2">
        <cfargument name="is_round" type="boolean" required="no" default="true">
        <cfscript>
        /*
        notes :
            negatif sayıları algılar, para birimi degerleri icin istenen degeri istenen kadar virgulle geri dondurur,
            ondalikli kisim default olarak yuvarlanir, ancak istenirse is_round false edilerek ondalik kadar kisimdan 
            yuvarlama olmasizin kesilebilir.
        parameters :
            1) money:formatlı yazdırılacak sayı (int veya float)
            2) no_of_decimal:ondalikli hane sayisi (int)
            3) is_round:yuvarlama yapilsin mi (boolean)
        usage : 
            <cfinput type="text" name="total" value="#TLFormat(x)#" validate="float">
            veya
            <cfinput type="text" name="total" value="#TLFormat(-123123.89)#" validate="float">
        revisions :
            20031105 - Temizlendi, uç nokta kontrolleri eklendi
            20031107 - 9 Katrilyon üstü desteği eklendi
            20031209 - 3 haneden küçük sayılar için negatif sayı desteği eklendi
            20041201 - Kurus (decimal) duzeltmeleri yapildi.
            20041201 - Genel duzenleme, kurus duzeltmelerine uygun yuvarlama .
            OZDEN 20070316 - round sorunlarının duzeltilmesi 
        */
        /*if (not len(arguments.money)) return 0;*/
        if (not len(arguments.money)) return '';
        arguments.money = trim(arguments.money);
        if (arguments.money contains 'E') arguments.money = ReplaceNoCase(NumberFormat(arguments.money),',','','all');
        if (arguments.money contains '-'){
            negativeFlag = 1;
            arguments.money = ReplaceNoCase(arguments.money,'-','','all');}
        else negativeFlag = 0;
        if(not isnumeric(arguments.no_of_decimal)) arguments.no_of_decimal= 2;	
        nokta = Find('.', arguments.money);
        if (nokta)
            {
            if(arguments.is_round) /* 20050823 and arguments.no_of_decimal */ 
            {
                rounded_value = CreateObject("java", "java.math.BigDecimal");
                rounded_value.init(arguments.money);
                rounded_value = rounded_value.setScale(arguments.no_of_decimal, rounded_value.ROUND_HALF_UP);
                rounded_value = rounded_value.toString();
                if(rounded_value contains '.') /*10.00 degeri yerine 10 dondurmek icin*/
                {
                    if(listlast(rounded_value,'.') eq 0)
                        rounded_value = listfirst(rounded_value,'.');
                }
                arguments.money = rounded_value;
                if (arguments.money contains 'E') 
                {
                    first_value = listgetat(arguments.money,1,'E-');
                    first_value = ReplaceNoCase(first_value,',','.');
                    last_value = ReplaceNoCase(listgetat(arguments.money,2,'E-'),'0','','all');
                    for(kk_float=1;kk_float lte last_value;kk_float=kk_float+1)
                    {
                        zero_info = ReplaceNoCase(first_value,'.','');
                        first_value = '0.#zero_info#';
                    }
                    arguments.money = first_value;
                    first_value = listgetat(arguments.money,1,'.');
                    arguments.money = "#first_value#.#Left(listgetat(arguments.money,2,'.'),8)#";
                    if(arguments.money lt 0.00000001) arguments.money = 0;
                    if(Find('.', arguments.money))
                    {
                        arguments.money = "#first_value#,#Left(listgetat(arguments.money,2,'.'),8)#";
                        return arguments.money;
                    }
                }
            }
            if(arguments.money neq 0) nokta = Find('.', arguments.money);
            if(ceiling(arguments.money) neq arguments.money){
                tam = ceiling(arguments.money)-1;
                onda = Mid(arguments.money, nokta+1,arguments.no_of_decimal);
                if(len(onda) lt arguments.no_of_decimal)
                    onda = onda & RepeatString(0,arguments.no_of_decimal-len(onda));
                }
            else{
                tam = arguments.money;
                onda = RepeatString(0,arguments.no_of_decimal);}
            }
        else{
            tam = arguments.money;
            onda = RepeatString(0,arguments.no_of_decimal);
            }
        textFormat='';
        t=0;
        if (len(tam) gt 3) 
            {
            for (k=len(tam); k; k=k-1)
                {
                t = t+1;
                if (not (t mod 3)) textFormat = '.' & mid(tam, k, 1) & textFormat; 
                else textFormat = mid(tam, k, 1) & textFormat;
                } 
            if (mid(textFormat, 1, 1) is '.') textFormat =  "#right(textFormat,len(textFormat)-1)#,#onda#";
            else textFormat =  "#textFormat#,#onda#";
            }
        else
            textFormat = "#tam#,#onda#";
            
        if (negativeFlag) textFormat =  "-#textFormat#";
        
        if (not arguments.no_of_decimal) 
            textFormat = ListFirst(textFormat,',');
        
        if(isdefined("moneyformat_style") and moneyformat_style eq 1)
            {
                textFormat = replace(textFormat,'.','*','all');
                textFormat = replace(textFormat,',','.','all');
                textFormat = replace(textFormat,'*',',','all');
            }
        return textFormat;
        </cfscript>
    </cffunction>

	<!--- Bu fonksiyon DB'ye bağlanıp query çeker. --->
    <cffunction name="cfquery" returntype="any" output="false">
        <!--- 
            usage : my_query_name = cfquery(SQLString:required,Datasource:required(bos olabilir),dbtype:optional,is_select:optinal); 
            Select olmayan yerlerde is_select:false olarak verilmelidir
        --->
        <cfargument name="SQLString" type="string" required="true">
        <cfargument name="Datasource" type="string" required="true">
        <cfargument name="dbtype" type="string" required="no">
        <cfargument name="is_select" type="boolean" required="no" default="true">
        
        <cfif isdefined("arguments.dbtype") and len(arguments.dbtype)>
            <cfquery name="workcube_cf_query" dbtype="query">
                #preserveSingleQuotes(arguments.SQLString)#
            </cfquery>
        <cfelse>
            <cfquery name="workcube_cf_query" datasource="#arguments.Datasource#">
                #preserveSingleQuotes(arguments.SQLString)#
            </cfquery>
        </cfif>
        <cfif arguments.is_select>
            <cfreturn workcube_cf_query>
        <cfelse>
            <cfreturn true>
        </cfif>
    </cffunction>
    
    <!--- Kendisine gelen employee_id yada position code'a göre kullanıcı bilgilerini gösterir. Linkli seçeneği mevcuttur. Kullanmamanız öneriler. Kaydı getirilecek veri left join ile bağlanmalıdır. --->
    <cffunction name="get_emp_info" returntype="string" output="false">
        <!--- 
        usage :	<cfoutput>#get_emp_info(187,1,1)#</cfoutput>
        parameters :
            1) employee_id veya position_code
            2) 0 ise employee_id verdim, 1 ise position_code verdim
            3) 0 veya 1 ; Linksiz veya Linkli,
            4) 0 veya 1 ; Pozisyon bos ise historydeki en son dolu calisani getirir (zorunlu degil)
        revisions :
            20031107, 20050913
        --->
        <cfargument name="emp_id" required="true">
        <cfargument name="type_" type="boolean" required="true">
        <cfargument name="with_link" type="boolean" required="true">
        <cfargument name="is_old_pos" type="boolean" required="false" default="0">
        <cfargument name="acc_type_id" type="string" required="false" default="0">
        <cfif not isnumeric(arguments.emp_id)><cfreturn ''></cfif>
        <cfset deger=''>
        <cfset acc_type_name_ = ''>
        <cfif arguments.acc_type_id neq 0 and len(arguments.acc_type_id)>
            <cfquery name="get_acc_name" datasource="#dsn#">
                SELECT ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID =  #arguments.acc_type_id#
            </cfquery>
            <cfif get_acc_name.recordcount><cfset acc_type_name_ = get_acc_name.acc_type_name></cfif>
        </cfif>
        <cfif arguments.type_ and isDefined('session.ep.userid') and arguments.emp_id eq session.ep.position_code>
            <cfif arguments.with_link>
                <cfset deger="<a href=""javascript://"" onclick=""openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#session.ep.userid#');"">#session.ep.name# #session.ep.surname#</a>">
            <cfelse>
                <cfset deger="#session.ep.name# #session.ep.surname#">
            </cfif>
        <cfelseif (not arguments.type_) and isDefined('session.ep.userid') and arguments.emp_id eq session.ep.userid>
            <cfif arguments.with_link>
                <cfset deger="<a href=""javascript://"" onclick=""openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#session.ep.userid#');"">#session.ep.name# #session.ep.surname#</a>">
            <cfelse>
                <cfset deger="#session.ep.name# #session.ep.surname#">
            </cfif>
        <cfelse>
            <cfquery name="GET_EMP_INFO_" datasource="#DSN#">
                SELECT
                    <cfif arguments.type_>POSITION_NAME,POSITION_ID,</cfif>EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID
                FROM
                    <cfif arguments.type_>EMPLOYEE_POSITIONS<cfelse>EMPLOYEES</cfif>
                WHERE
                    <cfif arguments.type_>POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"><cfelse>EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"></cfif>
            </cfquery>
            <cfif GET_EMP_INFO_.RECORDCOUNT and len(GET_EMP_INFO_.EMPLOYEE_ID) and len(GET_EMP_INFO_.EMPLOYEE_NAME)>
                <cfif arguments.with_link>
                    <cfset deger="<a href=""javascript://"" onclick=""openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_EMP_INFO_.EMPLOYEE_ID#');"">#GET_EMP_INFO_.EMPLOYEE_NAME# #GET_EMP_INFO_.EMPLOYEE_SURNAME#</a>">
                <cfelse>
                    <cfset deger="#GET_EMP_INFO_.EMPLOYEE_NAME# #GET_EMP_INFO_.EMPLOYEE_SURNAME#">
                </cfif>
            <cfelseif not len(GET_EMP_INFO_.EMPLOYEE_NAME) and not len(GET_EMP_INFO_.EMPLOYEE_SURNAME) and isdefined("GET_EMP_INFO_.POSITION_NAME")>
                <cfif arguments.is_old_pos and len(GET_EMP_INFO_.POSITION_ID)>
                    <cfquery name="Get_Old_Position" datasource="#dsn#">
                        SELECT TOP 1
                            E.EMPLOYEE_ID,
                            E.EMPLOYEE_NAME,
                            E.EMPLOYEE_SURNAME
                        FROM
                            EMPLOYEES E,
                            EMPLOYEE_POSITIONS_HISTORY EPH
                        WHERE
                            E.EMPLOYEE_ID = EPH.EMPLOYEE_ID AND
                            EPH.EMPLOYEE_ID IS NOT NULL AND
                            EPH.POSITION_ID = #GET_EMP_INFO_.POSITION_ID#
                        ORDER BY
                            EPH.RECORD_DATE DESC
                    </cfquery>
                    <cfif Get_Old_Position.RecordCount>
                        <cfif arguments.with_link>
                            <cfset deger="<a href=""javascript://"" onclick=""openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#Get_Old_Position.Employee_Id#');"">#GET_EMP_INFO_.POSITION_NAME# (#Get_Old_Position.Employee_Name# #Get_Old_Position.Employee_Surname#)</a>">
                        <cfelse>
                            <cfset deger="#GET_EMP_INFO_.POSITION_NAME# (#Get_Old_Position.Employee_Name# #Get_Old_Position.Employee_Surname#)">
                        </cfif>
                    <cfelse>
                        <cfset deger="(#GET_EMP_INFO_.POSITION_ID#) #GET_EMP_INFO_.POSITION_NAME# (Boş)">
                    </cfif>
                <cfelse>
                    <cfset deger="(#GET_EMP_INFO_.POSITION_ID#) #GET_EMP_INFO_.POSITION_NAME# (Boş)">
                </cfif>
            </cfif>
        </cfif>
        <cfif isdefined("acc_type_name_") and len(acc_type_name_)><cfset deger="#deger#-#acc_type_name_#"></cfif>
        <cfreturn trim(deger)>
    </cffunction>
    
    <!--- Kendisine gelen partner id yada position code a göre  partner'ın bilgilerini yazar. Kullanmayınız. Left join ile halledersiniz. --->
    <cffunction name="get_par_info" returntype="string" output="false">
    <!--- 
        usage : 
            <cfoutput>#get_par_info(45,1,1,1)#</cfoutput>
        parameters :
            1) member_id : sirketin veya calisanin 'id' si
            2) company_or_partner : (0 veya 1)  (Sirket Calisani, Sirket) member_id icin yazdiginiz deger sirket mi yoksa sirket calisanina mi aitti. 
            3) with_company_partner : (0 veya 1 veya -1)  Sirket Adi ve Partner Adi birlikte, Sadece Sirket Adi, Sadece Partner Adi
            4) with_link : (0 veya 1)  Linksiz, Linkli
     --->
        <cfargument name="member_id" required="true">
        <cfargument name="company_or_partner" type="boolean" required="true">
        <cfargument name="with_company_partner" type="numeric" required="true">
        <cfargument name="with_link" type="boolean" required="true">
        <cfargument name="acc_type_id" type="string" required="false" default="0">
        <cfargument name="is_nickname" type="boolean" default="0" required="false">
        <cfif not isnumeric(arguments.member_id)><cfreturn ''></cfif>
        <cfset deger=''>
        <cfset acc_type_name_ = ''>
        <cfif arguments.acc_type_id neq 0 and len(arguments.acc_type_id)>
            <cfquery name="get_acc_name" datasource="#dsn#">
                SELECT  ACCOUNT_TYPE_ID, ACCOUNT_TYPE FROM ACCOUNT_TYPES WHERE ACCOUNT_TYPE_ID =  #arguments.acc_type_id#
            </cfquery>
            <cfif get_acc_name.recordcount><cfset acc_type_name_ = get_acc_name.ACCOUNT_TYPE></cfif>
        </cfif>
        <cfif arguments.company_or_partner and isDefined('session.pp.company_id') and arguments.member_id eq session.pp.company_id>
            <cfif arguments.with_link><cfset deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#arguments.member_id#','medium');"" class=""tableyazi"">#session.pp.company#</a>">
            <cfelse><cfset deger="#session.pp.company#">
            </cfif>
        <cfelseif arguments.company_or_partner>
            <cfquery name="GET_PARTNER_INFO_" datasource="#dsn#">
                SELECT COMPANY_ID, NICKNAME, FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
            </cfquery>
            <cfif GET_PARTNER_INFO_.RECORDCOUNT>
                <cfif arguments.with_link><cfset deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_PARTNER_INFO_.COMPANY_ID#','medium');"" class=""tableyazi"">#GET_PARTNER_INFO_.FULLNAME#</a>">
                <cfelse><cfset deger="#GET_PARTNER_INFO_.FULLNAME#">
                </cfif>
            </cfif>
        <cfelseif (not arguments.company_or_partner) and isDefined('session.pp.userid') and arguments.member_id eq session.pp.userid>
            <cfscript>
                if(arguments.with_company_partner is 1)
                    if(arguments.with_link) deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#session.pp.company_id#','medium');"" class=""tableyazi"">#session.pp.company_nick#</a>";
                    else deger='#session.pp.company#';
                else if(arguments.with_company_partner is 0)
                    if (arguments.with_link)
                        {
                        deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#session.pp.company_id#','medium');"" class=""tableyazi"">#session.pp.company_nick#</a> - ";
                        deger=deger&"<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#session.pp.userid#','medium');"" class=""tableyazi"">#session.pp.name# #session.pp.surname#</a>";
                        }
                    else deger='#session.pp.company_nick# - #session.pp.name# #session.pp.surname#';
                else
                    if(arguments.with_link) deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#arguments.member_id#','medium');"" class=""tableyazi"">#session.pp.name# #session.pp.surname#</a>";
                    else deger="#session.pp.name# #session.pp.surname#";
            </cfscript>
        <cfelseif not arguments.company_or_partner>
            <cfquery name="GET_PARTNER_INFO_" datasource="#dsn#">
                SELECT COMPANY_PARTNER.PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME, COMPANY.COMPANY_ID, NICKNAME, FULLNAME FROM COMPANY_PARTNER, COMPANY WHERE COMPANY_PARTNER.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#"> AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
            </cfquery>
            <cfscript>
                if (GET_PARTNER_INFO_.RECORDCOUNT and len(GET_PARTNER_INFO_.COMPANY_PARTNER_NAME)) //calisana göre
                    {
                    if(arguments.with_company_partner is 1)
                        if (arguments.with_link) deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_PARTNER_INFO_.COMPANY_ID#','medium');"" class=""tableyazi"">#GET_PARTNER_INFO_.FULLNAME#</a>";
                        else {
                            if(arguments.is_nickname is 1) deger='#GET_PARTNER_INFO_.NICKNAME#';
                            else deger='#GET_PARTNER_INFO_.FULLNAME#';
                        }
                    else if(arguments.with_company_partner is 0)
                        if (arguments.with_link)
                            {
                            deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_PARTNER_INFO_.COMPANY_ID#','medium');"" class=""tableyazi"">#GET_PARTNER_INFO_.NICKNAME#</a> - ";
                            deger=deger&"<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#GET_PARTNER_INFO_.PARTNER_ID#','medium');"" class=""tableyazi"">#GET_PARTNER_INFO_.COMPANY_PARTNER_NAME# #GET_PARTNER_INFO_.COMPANY_PARTNER_SURNAME#</a>";
                            }
                        else deger='#GET_PARTNER_INFO_.NICKNAME# - #GET_PARTNER_INFO_.COMPANY_PARTNER_NAME# #GET_PARTNER_INFO_.COMPANY_PARTNER_SURNAME#';
                    else{
                        if (arguments.with_link) deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#GET_PARTNER_INFO_.PARTNER_ID#','medium');"" class=""tableyazi"">#GET_PARTNER_INFO_.COMPANY_PARTNER_NAME# #GET_PARTNER_INFO_.COMPANY_PARTNER_SURNAME#</a>";
                        else deger='#GET_PARTNER_INFO_.COMPANY_PARTNER_NAME# #GET_PARTNER_INFO_.COMPANY_PARTNER_SURNAME#';
                        }
                    }
            </cfscript>
        </cfif>
        <cfif isdefined("acc_type_name_") and len(acc_type_name_)><cfset deger="#deger#-#acc_type_name_#"></cfif>
        <cfreturn trim(deger)>
    </cffunction>

	<!--- Kendisine gelen ID veya position code'a göre consumer bilgisini gösterir. Kullanmayın. Left join bu iş için yaratılmış. --->
    <cffunction name="get_cons_info" returntype="string" output="false">
    <!--- 
        usage : 
            <cfoutput>#get_cons_info(98,1,1)#</cfoutput>
        parameters :
            1) consumer_id
            2) 0,1,2 ; Sirketsiz, Sirketli, Sadece Şirket Adı
            3) 0 veya 1 ; Linksiz veya Linkli 
     --->
        <cfargument name="consumer_id" required="true">
        <cfargument name="with_company" type="boolean" required="true">
        <cfargument name="with_link" type="boolean" required="true">
        <cfargument name="acc_type_id" type="string" required="false" default="0">
        <cfset acc_type_name_ = ''>
        <cfif arguments.acc_type_id neq 0 and len(arguments.acc_type_id)>
            <cfquery name="get_acc_name" datasource="#dsn#">
                SELECT  ACCOUNT_TYPE_ID, ACCOUNT_TYPE FROM ACCOUNT_TYPES WHERE ACCOUNT_TYPE_ID =  #arguments.acc_type_id#
            </cfquery>
            <cfif get_acc_name.recordcount><cfset acc_type_name_ = get_acc_name.ACCOUNT_TYPE></cfif>
        </cfif>
        <cfscript>
            deger='';
            if(not isnumeric(arguments.consumer_id))
                return deger;
            if(isDefined('session.ww.userid') and arguments.consumer_id eq session.ww.userid)
                {
                if(arguments.with_company eq 1)
                    if(arguments.with_link) deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#session.ww.userid#','medium');"" class=""tableyazi"">#session.ww.name# #session.ww.surname#</a> - #session.ww.company#";
                    else deger="#session.ww.name# #session.ww.surname# - #session.ww.company#";
                else if(arguments.with_company eq 0)
                    if(arguments.with_link) deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#session.ww.userid#','medium');"" class=""tableyazi"">#session.ww.name# #session.ww.surname#</a>";
                    else deger='#session.ww.name# #session.ww.surname#';
                else if(arguments.with_company eq 2)
                    if(arguments.with_link) deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#session.ww.userid#','medium');"" class=""tableyazi"">#session.ww.company#</a>";
                    else deger='#session.ww.company#';
                }
        </cfscript>
        <cfif len(deger)><cfreturn trim(deger)></cfif>
        <cfquery name="GET_CONSUMER_INFO_" datasource="#dsn#">
            SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME, COMPANY FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
        </cfquery>
        <cfscript>
            if(GET_CONSUMER_INFO_.RECORDCOUNT and len(GET_CONSUMER_INFO_.CONSUMER_ID) and len(GET_CONSUMER_INFO_.CONSUMER_NAME)){
                if(arguments.with_company eq 1){
                    if(arguments.with_link) deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#GET_CONSUMER_INFO_.CONSUMER_ID#','medium');"" class=""tableyazi"">#GET_CONSUMER_INFO_.CONSUMER_NAME# #GET_CONSUMER_INFO_.CONSUMER_SURNAME#</a> - #GET_CONSUMER_INFO_.COMPANY#";
                    else deger="#GET_CONSUMER_INFO_.CONSUMER_NAME# #GET_CONSUMER_INFO_.CONSUMER_SURNAME# - #GET_CONSUMER_INFO_.COMPANY#";
                    }
                else if(arguments.with_company eq 0){
                    if(arguments.with_link) deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#GET_CONSUMER_INFO_.CONSUMER_ID#','medium');"" class=""tableyazi"">#GET_CONSUMER_INFO_.CONSUMER_NAME# #GET_CONSUMER_INFO_.CONSUMER_SURNAME#</a>";
                    else deger='#GET_CONSUMER_INFO_.CONSUMER_NAME# #GET_CONSUMER_INFO_.CONSUMER_SURNAME#';
                    }
                else if(arguments.with_company eq 2){
                    if(arguments.with_link) deger="<a href=""javascript://"" onclick=""windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#GET_CONSUMER_INFO_.CONSUMER_ID#','medium');"" class=""tableyazi"">#GET_CONSUMER_INFO_.COMPANY#</a>";
                    else deger='#GET_CONSUMER_INFO_.COMPANY#';
                    }
                }
        </cfscript>
        <cfif isdefined("acc_type_name_") and len(acc_type_name_)><cfset deger="#deger#-#acc_type_name_#"></cfif>
        <cfreturn trim(deger)>
    </cffunction>

	<!--- Açıklamaya gerek görmedim. --->
    <cffunction name="get_product_name" returntype="string" output="false">
    <!--- 
        notes :
        usage : 
            <cfoutput>#get_product_name(product_id:98)#</cfoutput>
            veya <cfoutput>#get_product_name(stock_id:98,with_property:1)#</cfoutput>
        parameters :
            1) product_id ; numeric id
            2) stock_id ; numeric id
            3) with_property ; stok aciklamasi ile birlikte dondurur, stock_id parametresi yoksa bir ise yaramaz.
        revisions :
     --->
        <cfargument name="product_id" required="no" type="numeric">
        <cfargument name="stock_id" required="no" type="numeric">
        <cfargument name="with_property" required="no" type="boolean" default="false">
        <cfset urun_adi = ''>
        <cfif isDefined('arguments.product_id')>
            <cfquery name="GET_PRODUCT_NAME_FUNC" datasource="#dsn1#">
                SELECT PRODUCT_NAME, PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
            </cfquery>
            <cfset urun_adi = '#GET_PRODUCT_NAME_FUNC.PRODUCT_NAME#'>
        <cfelseif isDefined('arguments.stock_id')>
            <cfquery name="GET_PRODUCT_NAME_FUNC" datasource="#dsn3#">
                SELECT
                    PRODUCT_NAME,
                    PRODUCT_ID,
                    PROPERTY
                FROM
                    STOCKS
                WHERE
                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
            </cfquery>
            <cfif arguments.with_property>
                <cfset urun_adi = '#GET_PRODUCT_NAME_FUNC.PRODUCT_NAME# #GET_PRODUCT_NAME_FUNC.PROPERTY#'>
            <cfelse>
                <cfset urun_adi = '#GET_PRODUCT_NAME_FUNC.PRODUCT_NAME#'>
            </cfif>
        <cfelse>
            <cfset urun_adi = 'Ürün Adı Hatası!'>
        </cfif>
        <cfreturn urun_adi>
    </cffunction>

	<!--- Açıklamaya gerek görmedim. --->
    <cffunction name="get_position_id" returntype="string" output="no">
        <cfargument name="position_code" required="yes" type="numeric">
        <cfquery name="GET_P_ID" datasource="#dsn#">
            SELECT TOP 1 POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
        </cfquery>
        <cfset position_id_ = '#GET_P_ID.POSITION_ID#'>
        <cfreturn position_id_>
    </cffunction>

	<!--- Açıklamaya gerek görmedim. --->
    <cffunction name="get_project_name" returntype="string" output="false">
    <!--- 
        notes :
        usage : 
            <cfoutput>#get_project_name(project_id:98)#</cfoutput>
        parameters :
            1) project_id ; numeric id
        revisions :
     --->
        <cfargument name="project_id" required="no" type="numeric">
        <cfargument name="no" required="no" type="numeric" default="1">
        <cfset project_adi = ''>
        <cfif isDefined('arguments.project_id') and arguments.project_id eq -1>
            <cfset project_adi = "#getLang('main',1047,'Projesiz')#">
        <cfelseif isDefined('arguments.project_id')>
            <cfquery name="GET_PROJECT_NAME_FUNC" datasource="#dsn#">
                SELECT PROJECT_HEAD,PROJECT_ID,PROJECT_NUMBER,LANGUAGE_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
            </cfquery>
            <cfif len(GET_PROJECT_NAME_FUNC.LANGUAGE_ID)>
                <cfset project_name=getlang('','Proje Sözlük','#GET_PROJECT_NAME_FUNC.LANGUAGE_ID#')>
            <cfelse>
                <cfset project_name=GET_PROJECT_NAME_FUNC.PROJECT_HEAD>
            </cfif>
            <cfif no eq 1>
                <cfset project_adi = 'No:#replacelist(GET_PROJECT_NAME_FUNC.PROJECT_NUMBER,'<b>,</b>',',')# - #project_name#'>
            <cfelse>
                <cfset project_adi = '#project_name#'>
            </cfif>
        <cfelse>
            <cfset project_adi = 'Proje Adı Hatası!'>
        </cfif>
        <cfreturn project_adi>
    </cffunction>

    <!--- abone id parametresiyle abone numarasını geri döndürür  PY --->
    <cffunction name="get_subscription_no" returntype="string" output="false">
    <!--- 
        notes :
        usage : 
            <cfoutput>#get_subscription_no(subscription_id:1)#</cfoutput>
        parameters :
            1) subscription_id ; numeric id
        revisions :
     --->
        <cfargument name="subscription_id" required="no" type="numeric">
        <cfset subscription_no = ''>
        <cfif isDefined('arguments.subscription_id') and len(arguments.subscription_id)>
            <cfquery name="GET_SUBSCRIPTION" datasource="#dsn3#">
                SELECT SUBSCRIPTION_ID,SUBSCRIPTION_NO  FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
            </cfquery>
            <cfset subscription_no = '#replacelist(GET_SUBSCRIPTION.SUBSCRIPTION_NO,'<b>,</b>',',')#'>
        <cfelse>
            <cfset subscription_no = ''>
        </cfif>
        <cfreturn subscription_no>
    </cffunction>

	<!--- Açıklamaya gerek görmedim. --->
    <cffunction name="get_work_name" returntype="string" output="false">
    <!--- 
        notes : FBS 20090911
        usage : <cfoutput>#get_work_name(work_id:98)#</cfoutput>
        parameters : work_id ; numeric id
     --->
        <cfargument name="work_id" required="no" type="numeric">
        <cfset work_name = ''>
        <cfif isDefined('arguments.work_id')>
            <cfquery name="get_work_name_func" datasource="#dsn#">
                SELECT WORK_HEAD,WORK_ID FROM PRO_WORKS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
            </cfquery>
            <cfset work_name = '#get_work_name_func.work_head#'>
        <cfelse>
            <cfset work_name = 'İş Adı Hatası!'>
        </cfif>
        <cfreturn work_name>
    </cffunction>

	<!--- Kullanıcının online olup olmadığını kontrol ediyor. --->
    <cffunction name="get_workcube_app_user" returntype="query" output="false">
        <cfargument name="user_id" type="numeric" required="true">
        <cfargument name="user_type" type="numeric" required="true">
        <cfquery name="get_workcube_user" datasource="#DSN#">
            SELECT USERID FROM WRK_SESSION WHERE USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_id#"> AND USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_type#"> AND (IS_MOBILE IS NULL OR IS_MOBILE = 0)
        </cfquery>
        <cfreturn get_workcube_user>
    </cffunction>

	<!--- WRK_SESSION tablosundaki action page'i güncellemek için kullanılıyor.  --->
    <cffunction name="upd_workcube_app_action" output="false">
        <!---
        Usage :	kullanicinin session bilgileri hala var ve bulundugu sayfa objects.popup_banner degilse kullanicinin
                hareket bilgisi guncellenir	(ki zaten fuseaction emptypopup ile basliyorsa bu fonksiyon cagrilamaz) 
        --->
        <cfargument name="user_type" type="numeric" required="true">
        <cfif isdefined('session.ep.userid') or isdefined('session.pp.userid') or isdefined('session.ww.userid') or isdefined('session.pda.userid')>
            <cfif not listfindnocase('objects.popup_banner,objects.popup_add_basket_row_from_barcod,objects2.pm_kontrol,prod.popup_add_production_result,agenda.form_event_ajax,objects.xml_setting_personality',attributes.fuseaction)>
                <cfif not FindNoCase('ajax_box_page',page_code)>
                    <cfif arguments.user_type eq 0>
                        <cfset app_user_id_ = session.ep.userid>
                        <cfset workcubeId = session.ep.workcube_id>
                    <cfelseif arguments.user_type eq 1>
                        <cfset app_user_id_ = session.pp.userid>
                        <cfset workcubeId = session.pp.workcube_id>
                    <cfelseif arguments.user_type eq 5>
                        <cfset app_user_id_ = session.pda.userid>
                        <cfset workcubeId = session.pda.workcube_id>
                    <cfelse>
                        <cfset app_user_id_ = session.ww.userid>
                        <cfset workcubeId = session.ww.workcube_id>
                    </cfif>
                        <cfstoredproc procedure="UPDATE_WRK_ACTION_PROCEDURE" datasource="#dsn#">
                        <cfprocparam type="IN" cfsqltype="cf_sql_integer" value="#arguments.user_type#">
                        <cfprocparam type="IN" cfsqltype="cf_sql_integer" value="#app_user_id_#">
                        <cfprocparam type="IN" cfsqltype="cf_sql_longvarchar" value="#attributes.fuseaction##page_code#" />
                        <cfprocparam type="IN" cfsqltype="cf_sql_timestamp" value="#now()#" />
                        <cfprocparam type="IN" cfsqltype="cf_sql_varchar" value="#attributes.fuseaction#"/>
                        <cfprocparam type="IN" cfsqltype="cf_sql_varchar" value="#workcubeId#"/>
                    </cfstoredproc>
                </cfif>
            </cfif>
        </cfif>
    </cffunction>

	<!--- Yukarıdaki arkadaşın yakın dostu --->
    <cffunction name="upd_workcube_session" returntype="boolean" output="false">
        <cfargument name="USERID" type="numeric" required="no">
        <cfargument name="USER_TYPE" type="numeric" required="no">
        <cfargument name="USERNAME" type="string" required="no">
        <cfargument name="NAME" type="string" required="no">
        <cfargument name="SURNAME" type="string" required="no">
        <cfargument name="POSITION_CODE" type="string" required="no">
        <cfargument name="MONEY" type="string" required="no">
        <cfargument name="TIME_ZONE" type="numeric" required="no">
        <cfargument name="POSITION_NAME" type="string" required="no">
        <cfargument name="LANGUAGE_ID" type="string" required="no">
        <cfargument name="DESIGN_ID" type="numeric" required="no">
        <cfargument name="DESIGN_COLOR" type="numeric" required="no">
        <cfargument name="COMPANY_ID" type="numeric" required="no">
        <cfargument name="COMPANY" type="string" required="no">
        <cfargument name="COMPANY_EMAIL" type="string" required="no">
        <cfargument name="COMPANY_NICK" type="string" required="no">
        <cfargument name="EHESAP" type="numeric" required="no">
        <cfargument name="MAXROWS" type="numeric" required="no">
        <cfargument name="USER_LOCATION" type="string" required="no">
        <cfargument name="USERKEY" type="string" required="no">
        <cfargument name="PERIOD_ID" type="numeric" required="no">
        <cfargument name="PERIOD_YEAR" type="numeric" required="no">
        <cfargument name="IS_INTEGRATED" type="numeric" required="no">
        <cfargument name="USER_LEVEL" type="string" required="no">
        <cfargument name="WORKCUBE_SECTOR" type="string" required="no">
        <cfargument name="BARCODE_REQUIRE" type="numeric" required="no">
        <cfargument name="IS_COST" type="numeric" required="no">
        <cfargument name="IS_COST_LOCATION" type="numeric" required="no">
        <cfargument name="IS_BRAND_TO_CODE" type="numeric" required="no">
        <cfargument name="ERROR_TEXT" type="string" required="no">
        <cfargument name="SESSIONID" type="string" required="no">
        <cfargument name="AUTHORITY_CODE_HR" type="numeric" required="no">
        <cfargument name="ADMIN_STATUS" type="numeric" required="no">
        <cfargument name="MENU_ID" type="numeric" required="no">
        <cfargument name="MONEY2" type="string" required="no">
        <cfargument name="TIMEOUT_LIMIT" type="numeric" required="no">
        <cfargument name="DISCOUNT_VALID" type="numeric" required="no">
        <cfargument name="DUEDATE_VALID" type="numeric" required="no">
        <cfargument name="PRICE_DISPLAY_VALID" type="numeric" required="no">
        <cfargument name="COST_DISPLAY_VALID" type="numeric" required="no">
        <cfargument name="RATE_VALID" type="numeric" required="no">
        <cfargument name="THEIR_RECORDS_ONLY" type="numeric" required="no">
        <cfargument name="MULTI_ANALYSIS_RESULT" type="numeric" required="no">
        <cfargument name="DOCK_PHONE" type="string" required="no">
        <cfargument name="REPORT_USER_LEVEL" type="string" required="no">
        <cfargument name="DATA_LEVEL" type="string" required="no">
        <cfargument name="WORKTIPS_OPEN" type="bit" required="no">
        <cfquery name="upd_workcube_session_query" datasource="#dsn#">
            UPDATE
                WRK_SESSION
            SET
            <cfif isdefined("arguments.USERID") and len(arguments.USERID)>USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#USERID#">,</cfif>
            <cfif isdefined("arguments.USER_TYPE") and len(arguments.USER_TYPE)>USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#USER_TYPE#">,</cfif>
            <cfif isdefined("arguments.USERNAME") and len(arguments.USERNAME)>USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#USERNAME#">,</cfif>
            <cfif isdefined("arguments.NAME") and len(arguments.NAME)>NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NAME#">,</cfif>
            <cfif isdefined("arguments.SURNAME") and len(arguments.SURNAME)>SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SURNAME#">,</cfif>
            <cfif isdefined("arguments.POSITION_CODE") and len(arguments.POSITION_CODE)>POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_CODE#">,</cfif>
            <cfif isdefined("arguments.MONEY") and len(arguments.MONEY)>MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MONEY#">,</cfif>
            <cfif isdefined("arguments.TIME_ZONE") and len(arguments.TIME_ZONE)>TIME_ZONE = <cfqueryparam cfsqltype="cf_sql_integer" value="#TIME_ZONE#">,</cfif>
            <cfif isdefined("arguments.POSITION_NAME") and len(arguments.POSITION_NAME)>POSITION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#POSITION_NAME#">,</cfif>
            <cfif isdefined("arguments.LANGUAGE_ID") and len(arguments.LANGUAGE_ID)>LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LANGUAGE_ID#">,</cfif>
            <cfif isdefined("arguments.DESIGN_ID") and len(arguments.DESIGN_ID)>DESIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#DESIGN_ID#">,</cfif>
            <cfif isdefined("arguments.DESIGN_COLOR") and len(arguments.DESIGN_COLOR)>DESIGN_COLOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#DESIGN_COLOR#">,</cfif>
            <cfif isdefined("arguments.COMPANY_ID") and len(arguments.COMPANY_ID)>COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#COMPANY_ID#">,</cfif>
            <cfif isdefined("arguments.COMPANY") and len(arguments.COMPANY)>COMPANY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#COMPANY#">,</cfif>
            <cfif isdefined("arguments.COMPANY_EMAIL") and len(arguments.COMPANY_EMAIL)>COMPANY_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#COMPANY_EMAIL#">,</cfif>
            <cfif isdefined("arguments.COMPANY_NICK") and len(arguments.COMPANY_NICK)>COMPANY_NICK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#COMPANY_NICK#">,</cfif>
            <cfif isdefined("arguments.EHESAP") and len(arguments.EHESAP)>EHESAP = <cfqueryparam cfsqltype="cf_sql_smallint" value="#EHESAP#">,</cfif>
            <cfif isdefined("arguments.MAXROWS") and len(arguments.MAXROWS)>MAXROWS = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAXROWS#">,</cfif>
            <cfif isdefined("arguments.USER_LOCATION") and len(arguments.USER_LOCATION)>USER_LOCATION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#USER_LOCATION#">,</cfif>
            <cfif isdefined("arguments.USERKEY") and len(arguments.USERKEY)>USERKEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#USERKEY#">,</cfif>
            <cfif isdefined("arguments.PERIOD_ID") and len(arguments.PERIOD_ID)>PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PERIOD_ID#">,</cfif>
            <cfif isdefined("arguments.PERIOD_YEAR") and len(arguments.PERIOD_YEAR)>PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#PERIOD_YEAR#">,</cfif>
            <cfif isdefined("arguments.IS_INTEGRATED") and len(arguments.IS_INTEGRATED)>IS_INTEGRATED = <cfqueryparam cfsqltype="cf_sql_smallint" value="#IS_INTEGRATED#">,</cfif>
            <cfif isdefined("arguments.USER_LEVEL") and len(arguments.USER_LEVEL)>USER_LEVEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#USER_LEVEL#">,</cfif>
            <cfif isdefined("arguments.WORKCUBE_SECTOR")>WORKCUBE_SECTOR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#WORKCUBE_SECTOR#">,</cfif>
            <cfif isdefined("arguments.BARCODE_REQUIRE") and len(arguments.BARCODE_REQUIRE)>BARCODE_REQUIRE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#BARCODE_REQUIRE#">,</cfif>
            <cfif isdefined("arguments.IS_COST") and len(arguments.IS_COST)>IS_COST = <cfqueryparam cfsqltype="cf_sql_smallint" value="#IS_COST#">,</cfif>
            <cfif isdefined("arguments.IS_COST_LOCATION") and len(arguments.IS_COST_LOCATION)>IS_COST_LOCATION = <cfqueryparam cfsqltype="cf_sql_smallint" value="#IS_COST_LOCATION#">,</cfif>
            <cfif isdefined("arguments.IS_BRAND_TO_CODE") and len(arguments.IS_BRAND_TO_CODE)>IS_BRAND_TO_CODE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#IS_BRAND_TO_CODE#">,</cfif>
            <cfif isdefined("arguments.ERROR_TEXT") and len(arguments.ERROR_TEXT)>ERROR_TEXT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ERROR_TEXT#">,</cfif>
            <cfif isdefined("arguments.SESSIONID") and len(arguments.SESSIONID)>SESSIONID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSIONID#">,</cfif>
            <cfif isdefined("arguments.AUTHORITY_CODE_HR") and len(arguments.AUTHORITY_CODE_HR)>AUTHORITY_CODE_HR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#AUTHORITY_CODE_HR#">,</cfif>
            <cfif isdefined("arguments.ADMIN_STATUS") and len(arguments.ADMIN_STATUS)>ADMIN_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ADMIN_STATUS#">,</cfif>
            <cfif isdefined("arguments.PERIOD_DATE") and len(arguments.PERIOD_DATE)>PERIOD_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#PERIOD_DATE#">,</cfif>
            <cfif isdefined("arguments.TIMEOUT_LIMIT") and len(arguments.TIMEOUT_LIMIT)>TIMEOUT_MIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#TIMEOUT_LIMIT#">,</cfif>
            <cfif isdefined("arguments.MENU_ID") and len(arguments.MENU_ID)>MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MENU_ID#">,</cfif>
            <cfif isdefined("arguments.MONEY2") and len(arguments.MONEY2)>MONEY2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MONEY2#">,</cfif>
            <cfif isdefined("arguments.DISCOUNT_VALID") and len(arguments.DISCOUNT_VALID)>DISCOUNT_VALID = <cfqueryparam cfsqltype="cf_sql_smallint" value="#DISCOUNT_VALID#">,</cfif>
            <cfif isdefined("arguments.DUEDATE_VALID") and len(arguments.DUEDATE_VALID)>DUEDATE_VALID = <cfqueryparam cfsqltype="cf_sql_smallint" value="#DUEDATE_VALID#">,</cfif>
            <cfif isdefined("arguments.CONSUMER_PRIORITY") and len(arguments.CONSUMER_PRIORITY)>CONSUMER_PRIORITY = <cfqueryparam cfsqltype="cf_sql_smallint" value="#CONSUMER_PRIORITY#">,</cfif>
            <cfif isdefined("arguments.PRICE_DISPLAY_VALID") and len(arguments.PRICE_DISPLAY_VALID)>PRICE_DISPLAY_VALID = <cfqueryparam cfsqltype="cf_sql_smallint" value="#PRICE_DISPLAY_VALID#">,</cfif>
            <cfif isdefined("arguments.COST_DISPLAY_VALID") and len(arguments.COST_DISPLAY_VALID)>COST_DISPLAY_VALID = <cfqueryparam cfsqltype="cf_sql_smallint" value="#COST_DISPLAY_VALID#">,</cfif>
            <cfif isdefined("arguments.RATE_VALID") and len(arguments.RATE_VALID)>RATE_VALID = <cfqueryparam cfsqltype="cf_sql_smallint" value="#RATE_VALID#">,</cfif>
            <cfif isdefined("arguments.THEIR_RECORDS_ONLY") and len(arguments.THEIR_RECORDS_ONLY)>THEIR_RECORDS_ONLY = <cfqueryparam cfsqltype="cf_sql_smallint" value="#THEIR_RECORDS_ONLY#">,</cfif>
            <cfif isdefined("arguments.MULTI_ANALYSIS_RESULT") and len(arguments.MULTI_ANALYSIS_RESULT)>IS_MULTI_ANALYSIS_RESULT = <cfqueryparam cfsqltype="cf_sql_smallint" value="#MULTI_ANALYSIS_RESULT#">,</cfif>
            <cfif isdefined("arguments.DOCK_PHONE") and len(arguments.DOCK_PHONE)>DOCK_PHONE = <cfqueryparam cfsqltype="cf_sql_integer" value="#DOCK_PHONE#">,</cfif>
            <cfif isdefined("arguments.REPORT_USER_LEVEL") and len(arguments.REPORT_USER_LEVEL)>REPORT_USER_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#REPORT_USER_LEVEL#">,</cfif>
            <cfif isdefined("arguments.DATA_LEVEL") and len(arguments.DATA_LEVEL)>DATA_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#DATA_LEVEL#">,</cfif>
            <cfif isdefined("arguments.WORKTIPS_OPEN") and len(arguments.WORKTIPS_OPEN)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.WORKTIPS_OPEN#">,</cfif>
                CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#">
            WHERE
                CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#"> AND CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFID#">
        </cfquery>
        <cfreturn true>
    </cffunction>

	<!--- Kendisine gelen parametreye göre sayıyı düzenler. Sayının değeri ile yuvarlama katsayısı farklıysa farklı sayının yuvarlaması büyükse yuvarlar tersi durumda 0'lar ekler. --->
    <cffunction name="filterNum" returntype="string" output="false" hint="filternum">
        <!--- 
        by Ozden Ozturk 20070316
        notes :
            float veya integer alanların temizliği için kullanılır, js filterNum fonksiyonuyla aynı işlevi gorur
        parameters :
            1) str:formatlı yazdırılacak sayı (int veya float)
            2) no_of_decimal:ondalikli hane sayisi (int)
        usage : 
            filternum('124587,787',4)
            veya
            filternum(attributes.money,4)
         --->
        <cfargument name="str" required="yes">
        <cfargument name="no_of_decimal" required="no" default="2">	
        <cfscript>
        
        if((isdefined("moneyformat_style") and moneyformat_style eq 0) or (not isdefined("moneyformat_style")) or not isdefined("session.ep"))
        {
            if (not len(arguments.str)) return '';
            strCheck = '-;0;1;2;3;4;5;6;7;8;9;,';
            newStr = '';
            for(f_ind_i=1; f_ind_i lte len(arguments.str); f_ind_i=f_ind_i+1 )
            {
                if(listfind(strCheck, mid(arguments.str,f_ind_i,1),';'))
                    newStr = newStr&mid(arguments.str,f_ind_i,1);
            }
            newStr = replace(newStr,',','.','all');
            newStr = replace(newStr,',',' ','all');
        }
        else
        {
            if (not len(arguments.str)) return '';
            strCheck = '-;0;1;2;3;4;5;6;7;8;9;';
            newStr = '';
            for(f_ind_i=1; f_ind_i lte len(arguments.str); f_ind_i=f_ind_i+1 )
            {
                if(listfind(strCheck, mid(arguments.str,f_ind_i,1),';'))
                    newStr = newStr&mid(arguments.str,f_ind_i,1);
            }
            newStr = replace(str,',','','all');
        }
        </cfscript>
        <cfreturn wrk_round(newStr,no_of_decimal)>
    </cffunction>

	<!--- Listedeki fazlalıkları temizler. --->
    <cffunction name="ListDeleteDuplicates" returntype="string" output="false">
        <cfargument name="list" required="yes">
        <cfargument name="delim2" required="no" default=",">	
        <cfscript>
			var i = 1;
			var delimiter = arguments.delim2;
			var returnValue = '';
			list = ListToArray(arguments.list, delimiter);
			for(i = 1; i lte ArrayLen(list); i = i + 1)
				if(not ListFind(returnValue, list[i], delimiter))
					returnValue = ListAppend(returnValue, list[i], delimiter);
        </cfscript>
        <cfreturn returnValue>
    </cffunction>

	<!--- Listedeki fazlalıkları case sensitive olarak temizler. --->
    <cffunction name="ListDeleteDuplicatesNoCase" returntype="string" output="false">
        <cfargument name="list" required="yes">
        <cfargument name="delim" required="no" default=",">	
        <cfscript>
			var i = 1;
			var delimiter = arguments.delim;
			var returnValue = '';
			list = ListToArray(arguments.list, delimiter);
			for(i = 1; i lte ArrayLen(list); i = i + 1)
				if(not ListFindNoCase(returnValue, list[i], delimiter))
					returnValue = ListAppend(returnValue, list[i], delimiter);
        </cfscript>
        <cfreturn returnValue>
    </cffunction>
    
	<!--- Kısaltma hataları vardı. Bu yüzden kullanılıyor. --->
    <cffunction name="get_money_type" returntype="string" output="false">
        <cfargument name="money_type" required="yes">
        <cfscript>
			switch(arguments.money_type)
			{
				case 'TL' : money_type = "TL";break;
				case 'USD' : money_type = "USD";break;
				case 'EURO' : money_type = "EUR";break;
				case 'YEN' : money_type = "JPY";break;
				case 'POUND' : money_type = "POUND";break;
				case 'STERLIN' : money_type = "GBP";break;
				case 'KANADADOLARI' : money_type = "CAD";break;
				case 'ISVICREFRANGI' : money_type = "CHF";break;
				case 'AED' : money_type = "AED";break;
				case 'SEK' : money_type = "SEK";break;
				
				default : money_type = "";
			}
        </cfscript>
        <cfreturn money_type>
    </cffunction>
    
	<!--- Kısaltma hataları vardı. Bu yüzden kullanılıyor. --->
    <cffunction name="get_module_id" returntype="string" output="false">
        <cfargument name="module_name" required="yes">
        <cfscript>
			/*
			notes : DB'den de dondurulebilirdi ama gerek yok.
			usage :	get_module_id(form.module_name)
			parameters :
				1) module_name:fusebox.circuit, listfirst(attributes.fuseaction,'.'),attributes.modul_name vb verilerek module_id dondurur.
			revisions :
			*/
			switch(arguments.module_name){
				case 'project' : module_id = 1; break;
				case 'content' : module_id = 2; break;
				case 'hr' : module_id = 3; break;
				case 'member' : module_id = 4; break;
				case 'product' : module_id = 5; break;
				case 'agenda' : module_id = 6; break;
				case 'settings' : module_id = 7; break;
				case 'asset' : module_id = 8; break;
				case 'training' : module_id = 9; break;
				case 'forum' : module_id = 10; break;
				case 'sales' : module_id = 11; break;
				case 'purchase' : module_id = 12; break;
				case 'stock' : module_id = 13; break;
				case 'service' : module_id = 14; break;
				case 'campaign' : module_id = 15; break;
				case 'finance' : module_id = 16; break;
				case 'contract' : module_id = 17; break;
				case 'cash' : module_id = 18; break;
				case 'bank' : module_id = 19; break;
				case 'invoice' : module_id = 20; break;
				case 'cheque' : module_id = 21; break;
				case 'account' : module_id = 22; break;
				case 'ch' : module_id = 23; break;
				case 'fintab' : module_id = 24; break;
				case 'defin' : module_id = 25; break;
				case 'prod' : module_id = 26; break;
				case 'call' : module_id = 27; break;
				case 'webhaber' : module_id = 28; break;
				case 'correspondence' : module_id = 29; break;
				case 'process' : module_id = 30; break;
				case 'invent' : module_id = 31; break;
				case 'store' : module_id = 32; break;
				case 'report' : module_id = 33; break;
				case 'training_management' : module_id = 34; break;
				case 'production' : module_id = 35; break;
				case 'executive' : module_id = 36; break;
				case 'worknet' : module_id = 37; break;
				case 'video_conf' : module_id = 38; break;
				case 'spesific' : module_id = 39; break;
				case 'assetcare' : module_id = 40; break;
				case 'salesplan' : module_id = 41; break;
				case 'dev' : module_id = 42; break;
				case 'rule' : module_id = 43; break;
				case 'addressbook' : module_id = 44; break;
				case 'help' : module_id = 45; break;
				case 'budget' : module_id = 46; break;
				case 'objects' : module_id = 47; break;
				case 'ehesap' : module_id = 48; break;
				case 'cost' : module_id = 49; break;
				case 'pos' : module_id = 50; break;
				case 'credit' : module_id = 51; break;
				case 'crm' : module_id = 52; break;
				default : module_id = 0;}
        </cfscript>
        <cfreturn module_id>
    </cffunction>
    
	<!--- cfscript etiketi içinde include için oluşturulmuştur. --->
    <cffunction name="include" output="true" returntype="void">
        <cfargument name="template" type="string" required="true">
        <cfargument name="template_path" type="string" required="no" default="">
        <!--- 
        notes :
            cfscript tag i icinde dosya include etmek için kullanilir.
        parameters :
            1) template: string olarak full path verilmelidir.
        usage : 
            <cfscript>
                include('get_x.cfm','/some_path'); // pathi bilinen bir dosya icin
                ...
                include('get_x.cfm'); // include ettigimiz dosya ile aynı path de olanlar icin
            </cfscript>
        revisions :
     --->
        <cfscript>
        if(not len(arguments.template_path)){
            arguments.template_path = listdeleteat(replace( GetCurrentTemplatePath(), '\', '/', 'ALL') ,listlen(replace( GetCurrentTemplatePath(), '\', '/', 'ALL' ),"WMO/"),"WMO/");
            arguments.template_path = replace(arguments.template_path,listdeleteat(replace( GetBaseTemplatePath(), '\', '/', 'ALL'),listlen(replace( GetBaseTemplatePath(), '\', '/', 'ALL'),"WMO/"),"WMO/"),'','ALL');
            }
        </cfscript>
        <cfinclude template="#arguments.template_path#/#arguments.template#">
    </cffunction>

	<!--- CFscript içersinde sayfayı durdurmak için kullanılır. --->
    <cffunction name="abort" output="false" returntype="void">
        <cfargument name="message" type="string">
        <!--- 
        notes :
            cfscript tag i icinde abort etmek için kullanilir.
        parameters :
            1) message: string olarak mesaj verilebilir.
        usage : 
            <cfscript>
                abort();
                ...
                abort('Su oldu Bu oldu.');
                abort('İşlem Tarihi Su <script type="text/javascript">alert("Böyle Bir İs Olmaz!");window.location.href="#request.self#?fuseaction=myhome.welcome";</script>');
            </cfscript>
        revisions :
     --->
        <cfif len(arguments.message)><cfoutput>#arguments.message#</cfoutput></cfif>
        <cfabort>
    </cffunction>

	<!--- Dil dönüşümleri için kullanılır. --->
    <cffunction name="tr2asc" returntype="string" output="false">
        <cfargument name="tr_word" type="string" required="true">
            <cfscript>
                tr_new = replacelist(arguments.tr_word,"ş,Ş,ğ,Ğ,ı,İ","&##351;,&##350;,&##287;,&##286;,&##305;,&##304;");
            </cfscript>
        <cfreturn tr_new>
    </cffunction>
    <cffunction name="tr2eng" returntype="string" output="false">
        <cfargument name="tr_word" type="string" required="true">
            <cfscript>
                tr_new = replacelist(arguments.tr_word,"ş,Ş,ğ,Ğ,ı,İ,ü,Ü,ç,Ç,ö,Ö","s,S,g,G,i,I,u,U,c,C,o,O");
            </cfscript>
        <cfreturn tr_new>
    </cffunction>

	<!--- Unicode karakterleri DB'ye yazarken sorun oluyordu diye kullanılmıştı. Artık Admin panelinde kontrolü sağlanmaktadır. Admin panelde Datasource tanımlarındaki HIGH ASCI ile alakalı seçenek seçili olmalıdır.  --->
    <cffunction name="sql_unicode" returntype="string" output="false">
            <cfscript>
                    sql_add = 'N';
            </cfscript>
        <cfreturn sql_add>
    </cffunction>

	<!--- Lokasyon bilgilerini getirir. --->
    <cffunction name="get_location_info" returntype="string" output="false">
        <!--- 
        usage :	<cfoutput>#get_location_info(27,29,1,1)#</cfoutput>
        parameters :
            1) department_id
            2) location_id
            3) 0 veya 1 ; 1 departman ve lokasyon,0 sadece lokasyon (default 1)
            4) 0 veya 1 ; 0 branch_id degeri donmez, 1 branch_id degeri doner (default 0)
            
            4.parametre 1 olarak deger gonderilirse fonksiyon dizi halinde sonuc dondurur
            
        revisions :
            BK 20070613
            BK 20070621
        --->
        <cfargument name="department_id" required="true">
        <cfargument name="location_id" required="true">
        <cfargument name="type" type="boolean" default="1">
        <cfargument name="is_branch" type="boolean" default="0">
           
        <cfif not isnumeric(arguments.department_id)><cfreturn ''></cfif>
        <cfif not isnumeric(arguments.location_id)><cfreturn ''></cfif>
        <cfset deger=''>
        <cfquery name="GET_LOCATION_INFO_" datasource="#DSN#">
            SELECT 
                SL.COMMENT,
                D.DEPARTMENT_HEAD,
                D.BRANCH_ID
            FROM
                STOCKS_LOCATION SL,
                DEPARTMENT D
            WHERE 
                SL.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#"> AND
                SL.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"> AND
                SL.DEPARTMENT_ID = D.DEPARTMENT_ID
        </cfquery>
        <cfif GET_LOCATION_INFO_.RECORDCOUNT>
            <cfif arguments.type>
                <cfif arguments.is_branch>
                    <cfset deger='#GET_LOCATION_INFO_.DEPARTMENT_HEAD#-#GET_LOCATION_INFO_.COMMENT#,#GET_LOCATION_INFO_.BRANCH_ID#'>
                <cfelse>
                    <cfset deger='#GET_LOCATION_INFO_.DEPARTMENT_HEAD#-#GET_LOCATION_INFO_.COMMENT#'>
                </cfif>
            <cfelse>
                <cfif arguments.is_branch>
                    <cfset deger='#GET_LOCATION_INFO_.COMMENT#,#GET_LOCATION_INFO_.BRANCH_ID#'>
                <cfelse>
                    <cfset deger='#GET_LOCATION_INFO_.COMMENT#'>
                </cfif>
            </cfif>
        </cfif>
        <cfreturn trim(deger)>
    </cffunction>

	<!--- Objects2 tarafında kullanılıyor. --->
    <cffunction name="url_friendly_request" returntype="string" output="false">
        <cfargument name="url_friendly_request_real" default="1" type="string">
        <cfargument name="url_friendly_request_url" default="" type="string">
        <cfif len(arguments.url_friendly_request_url)>
            <cfreturn trim(arguments.url_friendly_request_url)>
        <cfelse>
            <cfreturn trim('#request.self#?fuseaction=#arguments.url_friendly_request_real#')>
        </cfif>
    </cffunction>

	<!--- DB verilerini xml'e dönüştürür. --->
    <cffunction name="wrk_xml" returntype="xml" output="false">
    <!--- TolgaS 20071107 verilen degerlere gore databesdeki kayıtların xml ini oluşturur XML oluşturma
        query_where : xml oluşacak tablodaki where bloğu
        query_order : xml oluşacak tablodaki order bloğu
        main_table  : ana tablo adı
        main_table_datasource : ana tablo dsn i
        main_table_related_columns : ana tablodaki hangi alanın sub tablolarla bağlanacak kolon adı
        sub_table_list : alt tablo listesi virgül ile ayrılmış biçimde
        sub_table_list_parent : tamamlanmadı yapım aşamasında alt tabloların baglı oldugu tablo 0 ise ana tablo 0 dan büyük ise sub_table_list den o elemana baglıdır
        sub_table_related_columns_list : ana tablo adı
        sub_table_datasource_list : alt tablo listesi virgül ile ayrılmış biçimde
        main_table_query_list : liste şeklinde sub query verilir vede bu query kolon şeklinde çekilir ana tablo kolonları ile
        sub_table_query_table_list : sub_table_query_list parametresi ile gelen querylerin hangi sub tabloya ait olduğunu gösterir
        sub_table_query_list : liste şeklinde sub query verilir vede bu query kolon şeklinde çekilir alt tablo kolonları ile
        query_string : tablolar verilerek çalıştırılmak istenmediği durumlarda query direk verile bilir
        query_string_datasource : query_string nin çalıştırılacağı datasoruce
        using : xml_doc = wrk_xml(main_table:'INVOICE',main_table_datasource:DSN2 ,query_where:'INVOICE_ID IN (293,284)',main_table_related_columns:'INVOICE_ID',sub_table_list:'INVOICE_ROW,INVOICE_MONEY',sub_table_datasource_list:'#DSN2#,#DSN2#',sub_table_related_columns_list:'INVOICE_ID,ACTION_ID');
    --->
        <cfargument name="main_table" type="string" default="">
        <cfargument name="main_table_datasource" type="string" default="#dsn#">
        <cfargument name="main_table_query_list" type="string" default="">
        <cfargument name="query_where" type="string" default="">
        <cfargument name="query_order" type="string" default="">
        <cfargument name="main_table_related_columns" type="string" default="">
        <cfargument name="sub_table_list" type="string" default="">
        <cfargument name="sub_table_datasource_list" type="string" default="">
        <cfargument name="sub_table_related_columns_list" type="string" default="">
        <cfargument name="sub_table_query_table_list" type="string" default="">
        <cfargument name="sub_table_query_list" type="string" default="">
        <cfargument name="query_string" type="string" required="no" default="">
        <cfargument name="query_string_datasource" type="string" default="dsn">
        <cfargument name="query_string_xml_tag_name" type="string" default="query_string">	
        <cfscript>
        xml_doc = XmlNew();
        xml_doc.xmlRoot = XmlElemNew(xml_doc,"WORKCUBE_XML");
        index_array = 1;
        //ACIKLAMA FONKSİYONA GELEN PARAMETRELER VE TARİH
        xml_doc.xmlRoot.XmlChildren[index_array] = XmlElemNew(xml_doc,"WORKCUBE_XML_DESCRIPTION");
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1] = XmlElemNew(xml_doc,"CREATION_SERVER_DATE");
        if(isdefined('session.ep'))
            xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1].XmlText = "#dateformat(NOW(),'dd/mm/yyyy')# #timeformat(dateadd("h",session.ep.time_zone,NOW()),"HH:MM")#";
        else
            xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1].XmlText = "#dateformat(NOW(),'dd/mm/yyyy')# #timeformat(NOW(),"HH:MM")#";
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[2] = XmlElemNew(xml_doc,"MAIN_TABLE");
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[2].XmlText = arguments.main_table;
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[3] = XmlElemNew(xml_doc,"MAIN_TABLE_DATASOURCE");
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[3].XmlText = arguments.main_table_datasource;
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[4] = XmlElemNew(xml_doc,"MAIN_TABLE_RELATED_COLUMNS");
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[4].XmlText = arguments.main_table_related_columns;
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[5] = XmlElemNew(xml_doc,"SUB_TABLE_LIST");
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[5].XmlText = arguments.sub_table_list;
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[6] = XmlElemNew(xml_doc,"SUB_TABLE_DATASOURCE_LIST");
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[6].XmlText = arguments.sub_table_datasource_list;
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[7] = XmlElemNew(xml_doc,"SUB_TABLE_RELATED_COLUMNS_LIST");
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[7].XmlText = arguments.sub_table_related_columns_list;
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[8] = XmlElemNew(xml_doc,"QUERY_STRING");
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[8].XmlText = arguments.query_string;
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[9] = XmlElemNew(xml_doc,"QUERY_STRING_DATASOURCE");
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[9].XmlText = arguments.query_string_datasource;
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[10] = XmlElemNew(xml_doc,"QUERY_STRING_XML_TAG_NAME");
        xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[10].XmlText = arguments.query_string_xml_tag_name;	
        index_array = index_array+1;
        
        if(not len(arguments.query_string))
        {
            if(len(arguments.main_table_query_list)) 
                main_sub_query = ', '&arguments.main_table_query_list;
            else
                main_sub_query = '';
            main_sql_text ='SELECT * #main_sub_query# FROM #arguments.main_table#';
    
    
            if(len(arguments.query_where)) main_sql_text = main_sql_text & ' WHERE #arguments.query_where#';
            if(len(arguments.query_order)) main_sql_text = main_sql_text & ' ORDER BY #arguments.query_order#';
            GET_MAIN_TABLE = cfquery(SQLString:main_sql_text,Datasource:main_table_datasource,is_select:1);
       
            for(main_query_ind=1;main_query_ind lte GET_MAIN_TABLE.RECORDCOUNT;main_query_ind=main_query_ind+1)
            {
                xml_doc.xmlRoot.XmlChildren[index_array] = XmlElemNew(xml_doc,"#main_table#");
                for(main_ind=1;main_ind lte listlen(GET_MAIN_TABLE.ColumnList,',');main_ind=main_ind+1)
                {
                    column_name=listgetat(#GET_MAIN_TABLE.ColumnList#,main_ind,',');
                    column_value=evaluate('GET_MAIN_TABLE.#column_name#[#main_query_ind#]');
                    
                    xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[main_ind] = XmlElemNew(xml_doc,"#column_name#");
                    xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[main_ind].XmlText = column_value ;
                }
                if(listlen(arguments.sub_table_list,','))
                {
                    for(sub_table_ind=1;sub_table_ind lte listlen(sub_table_list,',');sub_table_ind=sub_table_ind+1)
                    {
                        sub_table_name=listgetat(arguments.sub_table_list,sub_table_ind,',');
                        sub_table_related_colums=listgetat(arguments.sub_table_related_columns_list,sub_table_ind,',');
                        sub_table_datasource=listgetat(arguments.sub_table_datasource_list,sub_table_ind,',');
                        
                        if(listfind(arguments.sub_table_query_table_list,sub_table_name,',')) 
                            sub_query = ', '&arguments.sub_table_query_list;
                        else
                            sub_query = '';
                        
                        sub_sql_text ='SELECT * #sub_query# FROM #sub_table_name#';
                        if(len(sub_table_related_colums) and len(main_table_related_columns)) sub_sql_text = sub_sql_text & ' WHERE #sub_table_related_colums# = #evaluate('GET_MAIN_TABLE.#main_table_related_columns#[#main_query_ind#]')#';
                        'GET_SUB_TABLE_#sub_table_ind#' = cfquery(SQLString:sub_sql_text,Datasource:sub_table_datasource,is_select:1);
                  
                        sub_table_name=listgetat(sub_table_list,sub_table_ind,',');
                        sub_index=1;
                        if(isdefined('GET_SUB_TABLE_#sub_table_ind#') and evaluate('GET_SUB_TABLE_#sub_table_ind#.RECORDCOUNT') )
                        {
                            xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[main_ind] = XmlElemNew(xml_doc,"#sub_table_name#");
                            for(sub_query_ind=1;sub_query_ind lte evaluate('GET_SUB_TABLE_#sub_table_ind#.RECORDCOUNT');sub_query_ind=sub_query_ind+1)
                            {
                                xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[main_ind].XmlChildren[sub_query_ind] = XmlElemNew(xml_doc,"ROW_COUNT");
                                xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[main_ind].XmlChildren[sub_query_ind].XmlText = sub_query_ind;
                                for(sub_ind=1;sub_ind lte listlen(evaluate("GET_SUB_TABLE_#sub_table_ind#.ColumnList"),',');sub_ind=sub_ind+1)
                                {
                                    sub_column_name=listgetat(#evaluate("GET_SUB_TABLE_#sub_table_ind#.ColumnList")#,sub_ind,',');
                                    sub_column_value=evaluate('GET_SUB_TABLE_#sub_table_ind#.#sub_column_name#[#sub_query_ind#]');
                                    xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[main_ind].XmlChildren[sub_query_ind].XmlChildren[sub_ind] = XmlElemNew(xml_doc,"#sub_column_name#");
                                    xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[main_ind].XmlChildren[sub_query_ind].XmlChildren[sub_ind].XmlText = sub_column_value;
                                }
                            }
                            main_ind=main_ind+1;
                        }
                    }
                }
                index_array=index_array+1;
            }
        }else
        {
            GET_MAIN_TABLE = cfquery(SQLString:arguments.query_string,Datasource:arguments.query_string_datasource,is_select:1);
            for(main_query_ind=1;main_query_ind lte GET_MAIN_TABLE.RECORDCOUNT;main_query_ind=main_query_ind+1)
            {
                xml_doc.xmlRoot.XmlChildren[index_array] = XmlElemNew(xml_doc,"#arguments.query_string_xml_tag_name#");
                xml_doc.xmlRoot.XmlChildren[index_array].XmlText = GET_MAIN_TABLE.RECORDCOUNT;
                for(main_ind=1;main_ind lte listlen(GET_MAIN_TABLE.ColumnList,',');main_ind=main_ind+1)
                {
                    column_name=listgetat(#GET_MAIN_TABLE.ColumnList#,main_ind,',');
                    column_value=evaluate('GET_MAIN_TABLE.#column_name#[#main_query_ind#]');
                    
                    xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[main_ind] = XmlElemNew(xml_doc,"#column_name#");
                    xml_doc.xmlRoot.XmlChildren[index_array].XmlChildren[main_ind].XmlText = column_value ;
                }
                index_array=index_array+1;
            }
        }
        </cfscript>
        <cfreturn xml_doc>
    </cffunction>

	<!--- Xml okuyup değişkenlere atamalar yapıyor. --->
    <cffunction name="wrk_xml_read" output="yes">
    <!--- TolgaS 20071107
        verilen xml dosyayı okur ve degişkenler ile degerler oluşur
        xml_file : xml dosyası
        xml_data :  dosya yerine direk data verileceğinde bu kullanılmalı
        xml_charset : xml in karakter seti
        note: kötü yazılmış koddur daha iyisi yazılabilir yazdıklarımızda var ancak bazı şartlar bu şekilde yazdırdı kullanıldığı yerler düzenlenirse sınırsız kırılım inebilir hale getirilir ise iyi olur.
        using : xml_doc = wrk_xml(main_table:'INVOICE',main_table_datasource:DSN2 ,query_where:'INVOICE_ID IN (293,284)',main_table_related_columns:'INVOICE_ID',sub_table_list:'INVOICE_ROW,INVOICE_MONEY',sub_table_datasource_list:'#DSN2#,#DSN2#',sub_table_related_columns_list:'INVOICE_ID,ACTION_ID');
    --->
        <cfargument name="xml_file" type="string">
        <cfargument name="xml_data" type="string">
        <cfargument name="xml_charset" type="string" default="utf-8">
        <cfif isdefined('arguments.xml_file')>
            <cffile action="read" file="#arguments.xml_file#" variable="arguments.xml_data" charset="#arguments.xml_charset#">
        </cfif>
        <cfscript>
            xml_doc = XmlParse(arguments.xml_data);
            xml_root_name = xml_doc.xmlroot.xmlname;
            
            xml_root = evaluate('xml_doc.#xml_root_name#.XmlChildren');
            main_tag_len = ArrayLen(xml_root);
            for(m_ind=1;m_ind lte main_tag_len;m_ind=m_ind+1)
            {
                xml_ = '#evaluate('xml_root[m_ind]')#';
                xml_name = '#evaluate('xml_root[m_ind].Xmlname')#';
                '#xml_name#' = '#xml_.XmlText#';
                sub_tag_len=ArrayLen('#evaluate('xml_root[m_ind].XmlChildren')#');
                //writeoutput("1111---#xml_name# : #evaluate('#xml_name#')#---#sub_tag_len#<br/>");
                for(d_ind=1;d_ind lte sub_tag_len;d_ind=d_ind+1)
                {//ana tablo satırlar donuyor
                    xml_sub='#evaluate("xml_root[m_ind].XmlChildren[d_ind]")#';
                    xml_sub_name = '#xml_sub.Xmlname#'&'_#m_ind#';
                    '#xml_name#_#xml_sub_name#' = '#xml_sub.XmlText#';
                    sub_tag_row_len=arraylen('#xml_sub.XmlChildren#');
                    //writeoutput("AAAA---#xml_name#_#xml_sub_name# : #evaluate('#xml_name#_#xml_sub_name#')#--#sub_tag_row_len#<br/>");
                    for(sub_count_row=1;sub_count_row lte sub_tag_row_len;sub_count_row=sub_count_row+1)
                    {//ana tablo ıcınde alt elemanarı olanvarmı varsa ona giriyor
                        xml_sub_row_root = '#evaluate("xml_sub.XmlChildren[sub_count_row]")#';
                        xml_sub_row_name = '#xml_sub_row_root.Xmlname#'&'_#d_ind#';
                        '#xml_name#_#xml_sub_name#_#xml_sub_row_name#' = '#xml_sub_row_root.XmlText#';
                        //writeoutput("BBBB---#xml_name#_#xml_sub_name#_#xml_sub_row_name# : #evaluate('#xml_name#_#xml_sub_name#_#xml_sub_row_name#')#---#arraylen('#xml_sub_row_root.XmlChildren#')#<br/>");
                        for(sub_sub_count_row=1;sub_sub_count_row lte arraylen('#xml_sub_row_root.XmlChildren#');sub_sub_count_row=sub_sub_count_row+1)
                        {
                            xml_sub_sub_row_root = '#evaluate("xml_sub_row_root.XmlChildren[sub_sub_count_row]")#';
                            xml_sub_sub_name = '#xml_sub_sub_row_root.Xmlname#'&'_#sub_count_row#';
                            '#xml_name#_#xml_sub_name#_#xml_sub_sub_name#' = '#xml_sub_sub_row_root.XmlText#';
                            //writeoutput("CCCCC----#xml_name#_#xml_sub_name#_#xml_sub_sub_name# : #evaluate('#xml_name#_#xml_sub_name#_#xml_sub_sub_name#')#<br/>");
                        }
                    }
                }
            }
        </cfscript>
    </cffunction>

	<!--- Bugünün tarihini 29/02/2008 şekline dönüştürür.--->
    <cffunction name="wrk_get_today" returntype="string" output="false">
        <!--- SM 29 Şubat sorunu nedeniyle isdate kontrolü de yapıp öyle gönderiyor. --->
        <cfset new_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
        <cfif not isdate(new_date)>
            <cfset new_date = "#day(now())-1#/#month(now())#/#session.ep.period_year#">
        </cfif>
        <cfreturn trim(new_date)>
    </cffunction>

	<!--- Js alertin CF versiyonu --->
    <cffunction name="alert" returntype="string" output="false">
        <!--- CF değişkenleri için yazıldı.JS'deki kullanımı ile aynı sadece sonundaki ; ibaresi yok.M.ER 07112008 --->
        <cfargument name="alert_param" type="string">
        <cfscript>
            if (not isdefined('arguments.alert_param')) return '<script type="text/javascript">alert();</script>';else return '<script type="text/javascript">alert("#arguments.alert_param#");</script>';
        </cfscript>
    </cffunction>

	<!--- Bazı sayfalarda browser'ın tipi kullanılıyor. O amaçla oluşturulmuş. --->
    <cffunction name="browserDetect" returntype="string" output="false">
        <cfscript>
        /**
     * Detects 130+ browsers.
     * v2 by Daniel Harvey, adds Flock/Chrome and Safari fix.         
     * v5 fix by RCamden based on bug found by Jeff Mayer
     * 
     * @param UserAgent 	 User agent string to parse. Defaults to cgi.http_user_agent. (Optional)
     * @return Returns a string. 
     * @author John Bartlett (jbartlett@strangejourney.net) 
     * @version 5, October 10, 2011 
     */
    
    
        // Default User Agent to the CGI browser string
        var UserAgent=CGI.HTTP_USER_AGENT;
        
        // Regex to parse out version numbers
        var VerNo="/?v?_? ?v?[\(?]?([A-Z0-9]*\.){0,9}[A-Z0-9\-.]*(?=[^A-Z0-9])";
        
        // List of browser names
        var BrowserList="";
        
        // Identified browser info
        var BrowserName="";
        var BrowserVer="";
        
        // Working variables
        var Browser="";
        var tmp="";
        var tmp2="";
        var x=0;
        
        
        // If a value was passed to the function, use it as the User Agent
        if (ArrayLen(Arguments) EQ 1) UserAgent=Arguments[1];
        
        // Allow regex to match on EOL and instring
        UserAgent=UserAgent & " ";
        
        // Browser List (Allows regex - see BlackBerry for example)
        BrowserList="1X|Amaya|Ubuntu APT-HTTP|AmigaVoyager|Android|Arachne|Amiga-AWeb|Arora|Bison|Bluefish|Browsex|Camino|Check&Get|Chimera|Chrome|Contiki|cURL|Democracy|" &
                    "Dillo|DocZilla|edbrowse|ELinks|Emacs-W3|Epiphany|Galeon|Minefield|Firebird|Phoenix|Flock|IceApe|IceWeasel|IceCat|Gnuzilla|" &
                    "Google|Google-Sitemaps|HTTPClient|HP Web PrintSmart|IBrowse|iCab|ICE Browser|Kazehakase|KKman|K-Meleon|Konqueror|Links|Lobo|Lynx|Mosaic|SeaMonkey|" &
                    "muCommander|NetPositive|Navigator|NetSurf|OmniWeb|Acorn Browse|Oregano|Prism|retawq|Shiira Safari|Shiretoko|Sleipnir|Songbird|Strata|Sylera|" &
                    "ThunderBrowse|W3CLineMode|WebCapture|WebTV|w3m|Wget|Xenu_Link_Sleuth|Oregano|xChaos_Arachne|WDG_Validator|W3C_Validator|" &
                    "Jigsaw|PLAYSTATION 3|PlayStation Portable|IPD|" &
                    "AvantGo|DoCoMo|UP.Browser|Vodafone|J-PHONE|PDXGW|ASTEL|EudoraWeb|Minimo|PLink|NetFront|Xiino|";
                    // Mobile strings
                    BrowserList=BrowserList & "iPhone|Vodafone|J-PHONE|DDIPocket|EudoraWeb|Minimo|PLink|Plucker|NetFront|PIE|Xiino|" &
                    "Opera Mini|IEMobile|portalmmm|OpVer|MobileExplorer|Blazer|MobileExplorer|Opera Mobi|BlackBerry\d*[A-Za-z]?|" &
                    "PPC|PalmOS|Smartphone|Netscape|Opera|Safari|Firefox|MSIE|HP iPAQ|LGE|MOT-[A-Z0-9\-]*|Nokia|";
        
                    // No browser version given
                    BrowserList=BrowserList & "AlphaServer|Charon|Fetch|Hv3|IIgs|Mothra|Netmath|OffByOne|pango-text|Avant Browser|midori|Smart Bro|Swiftfox";
        
                    // Identify browser and version
        Browser=REMatchNoCase("(#BrowserList#)/?#VerNo#",UserAgent);
        
        if (ArrayLen(Browser) GT 0) {
        
            if (ArrayLen(Browser) GT 1) {
        
                // If multiple browsers detected, delete the common "spoofed" browsers
                if (Browser[1] EQ "MSIE 6.0" AND Browser[2] EQ "MSIE 7.0") ArrayDeleteAt(Browser,1);
                if (Browser[1] EQ "MSIE 7.0" AND Browser[2] EQ "MSIE 6.0") ArrayDeleteAt(Browser,2);
                tmp2=Browser[ArrayLen(Browser)];
        
                for (x=ArrayLen(Browser); x GTE 1; x=x-1) {
                    tmp=Rematchnocase("[A-Za-z0-9.]*",Browser[x]);
                    if (ListFindNoCase("Navigator,Netscape,Opera,Safari,Firefox,MSIE,PalmOS,PPC",tmp[1]) GT 0) ArrayDeleteAt(Browser,x);
                }
        
                if (ArrayLen(Browser) EQ 0) Browser[1]=tmp2;
            }
        
            // Seperate out browser name and version number
            tmp=Rematchnocase("[A-Za-z0-9. _\-&]*",Browser[1]);
    
            Browser=tmp[1];
        
            if (ArrayLen(tmp) EQ 2) BrowserVer=tmp[2];
        
            // Handle "Version" in browser string
            tmp=REMatchNoCase("Version/?#VerNo#",UserAgent);
            if (ArrayLen(tmp) EQ 1) {
                tmp=Rematchnocase("[A-Za-z0-9.]*",tmp[1]);
                //hack added by Camden to try better handle weird UAs
                if(arrayLen(tmp) eq 2) BrowserVer=tmp[2];
                else browserVer=tmp[1];
            }
        
            // Handle multiple BlackBerry browser strings
            if (Left(Browser,10) EQ "BlackBerry") Browser="BlackBerry";
        
            // Return result
            return Browser & " " & BrowserVer;
        
        }
        //FCK editör İE 11 sürümü için degisilik yapıldı
        ie11v = FindNoCase("Trident/7.0; rv:11",userAgent);
        if (ie11v)
        return "MSIE " & Mid(userAgent,ie11v+16,4);
        
        // Unable to identify browser
        return "Unknown";
    
    
        </cfscript>
    </cffunction>

	<!--- İki tarih arasındaki zamanı gün-saat-dakika şeklinde gösteriyor --->
    <cffunction name="get_date_part" returntype="string" output="false">
        <!--- 
        usage :	<cfoutput> #get_date_part(care_date,care_finish_date)#</cfoutput>
        parameters :
            1) baslangic tarihi
            2) bitis tarihi
            
            15 gun 20 saat 5 dk cikis formati
        revisions :
            BK 20081127
        --->
        <cfargument name="date1" type="string" required="yes">
        <cfargument name="date2" type="string" required="yes">
        <cfif not isdate(arguments.date1)><cfreturn ''></cfif>
        <cfif not isdate(arguments.date2)><cfreturn ''></cfif>
    
        <cfset temp_day=''>
        <cfset temp_hour=''>
        <cfset temp_minute=''>
        <cfset new_str=''>
    
        <cfset total_minute = datediff("n",arguments.date1,arguments.date2)>

        <cfif total_minute gte 1440>
            <cfset temp_day = Int(total_minute/1440)>
            <cfset new_str = "#temp_day# #getLang('main',78)#">
            <cfset remaining_hour = total_minute mod 1440>
            <cfif remaining_hour gte 60>
                <cfset temp_hour = Int(remaining_hour/60)>
                <cfset remaining_minute = remaining_hour mod 60>
                <cfif remaining_minute neq 0>
                    <cfset temp_minute = remaining_minute>			
                </cfif>
            <cfelse>
                <cfif remaining_hour neq 0>
                    <cfset temp_minute = remaining_hour>			
                </cfif>
            </cfif>
        <cfelse>
            <cfif total_minute gte 60>
                <cfset temp_hour = Int(total_minute/60)>
                <cfset remaining_minute = total_minute mod 60>
                <cfif remaining_minute neq 0>
                    <cfset temp_minute = remaining_minute>			
                </cfif>
            <cfelse>
                <cfif total_minute neq 0>
                    <cfset temp_minute = total_minute>			
                </cfif>
            </cfif>
        </cfif>	
        <cfif len(temp_day)>
            <cfset new_str = "#temp_day# #getLang('main',78)#">
        </cfif>
        <cfif len(temp_hour)>
            <cfif len(new_str)>
                <cfset new_str = "#new_str# #temp_hour# #getLang('main',79)#">
            <cfelse>
                <cfset new_str = "#temp_hour# #getLang('main',79)#">
            </cfif>
        </cfif>
        <cfif len(temp_minute)>
            <cfif len(new_str)>
                <cfset new_str = "#new_str# #temp_minute# #getLang('main',715)#">
            <cfelse>
                <cfset new_str = "#temp_minute# #getLang('main',715)#">
            </cfif>
        </cfif>
        <cfreturn new_str>
    </cffunction>

	<!--- Boşluk karakterinin karşılığı--->
    <cffunction name="nbsp" returntype="string" output="false">
        <cfargument name="td_type" default="0">
        <cfscript>
            if(len(arguments.td_type) and arguments.td_type eq 0)//csv formatında
            {
                a = '';
            }
            else //excel ve standart yapıda
                a = '&nbsp;';
            return a;
        </cfscript>
    </cffunction>

	<!--- CF dateAdd fonksiyonunun başkalaşmış halidir --->
    <cffunction name="date_add" returntype="any" output="true">
        <cfargument name="type" type="string" required="true">
        <cfargument name="value" type="string" required="true">
        <cfargument name="date" type="string" required="true">
        <cfif type is 'h'>
            <cfset deger_ = value * 60>
            <cfset date_new_ = dateadd("n",deger_,date)>
        <cfelse>
            <cfset date_new_ = dateadd("#type#",value,date)>
        </cfif>
        <cfreturn date_new_>
    </cffunction>

	<!--- Kurulum sırasında sistemin kaç kullanıcı tarafından kullanılacağı belirtilir. Buna göre sistemin maksimum kullanıcı sayısı bulunur. Online kullanıcı sayısı maksimum'a ulaştığında yeni girişlere izin verilmez. act_login dosyasında kontrol ediliyor.  --->
    <cffunction name="session_tree_cont" returntype="any" output="true">
        <cfquery name="get_users" datasource="#dsn#">
            SELECT
                COUNT(USERID) AS ACTIVE_USERS
            FROM
                WRK_SESSION
        </cfquery>
        <cfset domain_ = listgetat(employee_url,'1',';')>
        <cftry>
			<cfif Asc(Right(session_tree,1)) EQ 8203>
                <cfset session_tree = left(session_tree,len(session_tree)-1)>
            </cfif>
            <cfset max_user_ = decrypt('#session_tree#',domain_,'CFMX_COMPAT','Base64')>
            <cfif isnumeric(max_user_) and max_user_ gt get_users.ACTIVE_USERS>
                <cfset user_login_ = '1'>
            <cfelse>
                <cfset user_login_ = '0'>
            </cfif>
        <cfcatch type="any">
            <cfset user_login_ = 0>
        </cfcatch>
        </cftry>
        <cfreturn user_login_>
    </cffunction>

	<!--- İşlem kategorisinin case'e göre dildeki karşılığını bulur. --->
    <cffunction name="get_process_name" returntype="any" output="false">
        <cfargument name="process_cat" type="string" required="true">
        <cfsavecontent variable="process_type_">
        <cfswitch expression="#process_cat#">
            <!--- Muhasebe --->
            <cfcase value="10"><cf_get_lang_main no='1344.Açılış Fişi'></cfcase>
            <cfcase value="11"><cf_get_lang_main no='1432.Tahsil Fişi'></cfcase>
            <cfcase value="12"><cf_get_lang_main no='1542.Tediye Fişi'></cfcase>
            <cfcase value="13"><cf_get_lang_main no='1040.Mahsup Fişi'></cfcase>
            <cfcase value="14"><cf_get_lang_main no='1638.Özel Fiş'></cfcase>
            <cfcase value="16"><cf_get_lang_main no='1654.Enflasyon Muhasebesi'>></cfcase>
            <cfcase value="17"><cf_get_lang_main no='648.Virman'></cfcase>
            <cfcase value="18"><cf_get_lang_main no='1711.Demirbaş Yeniden Değerleme'></cfcase>
            <cfcase value="19"><cf_get_lang_main no='1746.Kapanış Fişi'></cfcase>
            <cfcase value="302"><cf_get_lang_main no='2025.Reeskont Islemleri'></cfcase>
            <!--- Banka --->
            <cfcase value="20"><cf_get_lang_main no='1344.Açılış Fişi'></cfcase>
            <cfcase value="21"><cf_get_lang_main no='1747.İşlem (Para Yatırma)'></cfcase>
            <cfcase value="22"><cf_get_lang_main no='1748.İşlem (Para Çekme)'></cfcase>
            <cfcase value="23"><cf_get_lang_main no='1749.Banka Virman'></cfcase>
            <cfcase value="230"><cf_get_lang_main no='2085.Toplu Virman'></cfcase>
            <cfcase value="2311"><cf_get_lang dictionary_id='51369.Vadeli Mevduat Hesaba Yatır'></cfcase>
            <cfcase value="2313"><cf_get_lang dictionary_id='51388.Vadeli Mevduat Hesaba Geçiş'></cfcase>
            <cfcase value="24"><cf_get_lang_main no='422.Gelen Havale'></cfcase>
            <cfcase value="240"><cf_get_lang dictionary_id='29555.Toplu Giden Havale'></cfcase>
            <cfcase value="241"><cf_get_lang_main no='424.Kredi Kartı Tahsilat'></cfcase>
            <cfcase value="2410"><cf_get_lang_main no='645.Toplu'><cf_get_lang_main no='424.Kredi Kartı Tahsilat'></cfcase>
            <cfcase value="242"><cf_get_lang_main no='1756.Kredi Kartıyla Ödeme'></cfcase>
            <cfcase value="243"><cf_get_lang_main no='1751.Kredi Kartı Hesaba Geçiş'></cfcase>
            <cfcase value="247"><cf_get_lang_main no='1752.Kredi Kartı Hesaba Geçiş İptal'></cfcase>
            <cfcase value="244"><cf_get_lang_main no='1753.Kredi Kartı Borcu Ödeme'></cfcase>
            <cfcase value="248"><cf_get_lang_main no='1754.Kredi Kartı Borcu Ödeme İptal'></cfcase>
            <cfcase value="245"><cf_get_lang_main no='1755.Kredi Kartı Tahsilat İptal'></cfcase>
            <cfcase value="246"><cf_get_lang_main no='1757.Kredi Kartıyla Ödeme İptal'></cfcase>
            <cfcase value="25"><cf_get_lang_main no='423.Giden Havale'></cfcase>
            <cfcase value="260"><cf_get_lang_main no='755.Giden Banka Talimatı'></cfcase>
            <cfcase value="251"><cf_get_lang_main no='753.Gelen Banka Talimatı'></cfcase>
            <cfcase value="250"><cf_get_lang_main no='1758.Toplu Giden Havale'></cfcase>
            <cfcase value="254"><cf_get_lang_main no='1759.Banka Kur Değerleme'></cfcase>
            <cfcase value="26"><cf_get_lang_main no='1761.Döviz Alış İşlemi'></cfcase>
            <cfcase value="27"><cf_get_lang_main no='1762.Döviz Satış İşlemi'></cfcase>
            <cfcase value="29"><cf_get_lang_main no='1760.Banka Masraf Fişi'></cfcase>
            <!--- Kasa --->
            <cfcase value="30"><cf_get_lang_main no='1344.Açılış Fişi'></cfcase>
            <cfcase value="31"><cf_get_lang_main no='433.Tahsilat'></cfcase>
            <cfcase value="310"><cf_get_lang_main no='1763.Toplu Tahsilat'></cfcase>
            <cfcase value="32"><cf_get_lang_main no='1764.Cari Ödeme'></cfcase>
            <cfcase value="320"><cf_get_lang_main no='1765.Toplu Ödeme'></cfcase>
            <cfcase value="33"><cf_get_lang_main no='1766.Kasa Virman'></cfcase>
            <cfcase value="34"><cf_get_lang_main no='1767.Mal Alım Faturası Kapama İşlemi'></cfcase>
            <cfcase value="35"><cf_get_lang_main no='1768.Mal Satış Faturası Kapama İşlemi'></cfcase>
            <cfcase value="37"><cf_get_lang_main no='1769.Kasa Masraf Fişi'></cfcase>
            <cfcase value="38"><cf_get_lang_main no='1761.Döviz Alış İşlemi'></cfcase>
            <cfcase value="39"><cf_get_lang_main no='1762.Döviz Satış İşlemi'></cfcase>
            <cfcase value="311"><cf_get_lang_main no='802.Kasa Kur Değerleme İşlemi'></cfcase>
            <!--- Cari Hesaplar --->
            <cfcase value="40"><cf_get_lang_main no='1344.Açılış Fişi'></cfcase>
            <cfcase value="41"><cf_get_lang_main no='437.Borç Dekontu'></cfcase>
            <cfcase value="42"><cf_get_lang_main no='436.Alacak Dekontu'></cfcase>
            <cfcase value="43"><cf_get_lang_main no='1770.Cari Virman'></cfcase>
            <cfcase value="44"><cf_get_lang_main no='1771.Prim Ödeme'></cfcase>
            <cfcase value="36"><cf_get_lang_main no='1772.Şube Kasa Raporu'></cfcase>
            <cfcase value="45"><cf_get_lang_main no='1483.Borç Kur Değerleme Dekontu'></cfcase>
            <cfcase value="46"><cf_get_lang_main no='1482.Alacak Kur Değerleme Dekontu'></cfcase>
            <cfcase value="410"><cf_get_lang_main no='1773.Toplu Borç Dekontu'></cfcase>
            <cfcase value="420"><cf_get_lang_main no='1774.Toplu Alacak Dekontu'></cfcase>
            <!--- Fatura --->
            <cfcase value="48"><cf_get_lang_main no='1775.Verilen Kur Farkı Faturası'></cfcase>
            <cfcase value="49"><cf_get_lang_main no='1776.Alınan Kur Farkı Faturası'></cfcase>
            <cfcase value="50"><cf_get_lang_main no='415.Verilen Vade Farkı Faturası'></cfcase>
            <cfcase value="51"><cf_get_lang_main no='351.Alınan Vade Farkı Faturası'></cfcase>
            <cfcase value="52"><cf_get_lang_main no='353.Perakende Satış Faturası'></cfcase>
            <cfcase value="53"><cf_get_lang_main no='413.Toptan Satış Faturası'></cfcase>
            <cfcase value="531"><cf_get_lang_main no='409.İhracat Faturası'></cfcase>
            <cfcase value="54"><cf_get_lang_main no='412.Perakende Satış İade Faturası'></cfcase>
            <cfcase value="55"><cf_get_lang_main no='356.Toptan Satış İade Faturası'></cfcase>
            <cfcase value="56"><cf_get_lang_main no='417.Verilen Hizmet Faturası'></cfcase>
            <cfcase value="561"><cf_get_lang_main no='416.Verilen Hakediş Faturası'></cfcase>
            <cfcase value="57"><cf_get_lang_main no='358.Verilen Proforma Faturası'></cfcase>
            <cfcase value="58"><cf_get_lang_main no='418.Verilen Fiyat Farkı Faturası'></cfcase>
            <cfcase value="59"><cf_get_lang_main no='410.Mal Alım Faturası'></cfcase>
            <cfcase value="591"><cf_get_lang_main no='408.İthalat Faturası'></cfcase>
            <cfcase value="592"><cf_get_lang_main no='407.Hal Faturası'></cfcase>
            <cfcase value="60"><cf_get_lang_main no='401.Alınan Hizmet Faturası'></cfcase>
            <cfcase value="601"><cf_get_lang_main no='400.Alınan Hakediş Faturası'></cfcase>
            <cfcase value="61"><cf_get_lang_main no='402.Alınan Proforma Faturası'></cfcase>
            <cfcase value="62"><cf_get_lang_main no='403.Alım İade Faturası'></cfcase>
            <cfcase value="63"><cf_get_lang_main no='399.Alınan Fiyat Farkı Faturası'></cfcase>
            <cfcase value="64"><cf_get_lang_main no='411.Müstahsil Makbuzu'></cfcase>
            <cfcase value="65"><cf_get_lang_main no='1777.Demirbaş Alış Faturası'></cfcase>
            <cfcase value="66"><cf_get_lang_main no='1778.Demirbaş Satış Faturası'></cfcase>
            <cfcase value="67"><cf_get_lang_main no='1779.Şube Toplu Satış İşlemi'></cfcase>
            <cfcase value="68"><cf_get_lang_main no='1780.Serbest Meslek Makbuzu'></cfcase>
            <cfcase value="690"><cf_get_lang_main no='405.Gider Pusulası(Mal)'></cfcase>
            <cfcase value="69"><cf_get_lang_main no='1026.Z Raporu'></cfcase>
            <cfcase value="691"><cf_get_lang_main no='406.Gider Pusulası(Hizmet)'></cfcase>
            <cfcase value="532"><cf_get_lang_main no='1781.Konsinye Satış Faturası'></cfcase>
            <cfcase value="533"><cf_get_lang_main no='2617.KDV den Muaf Satış Faturası'></cfcase>
            <cfcase value="5311"><cf_get_lang dictionary_id='61432.İhraç Kayıtlı Fatura'></cfcase>
            <!--- İrsaliye --->
            <cfcase value="70"><cf_get_lang_main no='1782.Perakende Satış İrsaliyesi'></cfcase>		
            <cfcase value="71"><cf_get_lang_main no='1340.Toptan Satış İrsaliyesi'></cfcase>		
            <cfcase value="72"><cf_get_lang_main no='1341.Konsinye Çıkış İrsaliyesi'></cfcase>		
            <cfcase value="73"><cf_get_lang_main no='1342.Perakende Satış İade İrsaliyesi'></cfcase>		
            <cfcase value="74"><cf_get_lang_main no='1783.Toptan Satış İade İrsaliyesi'></cfcase>		
            <cfcase value="75"><cf_get_lang_main no='1343.Konsinye Çıkış İade İrsaliyesi'></cfcase>		
            <cfcase value="76"><cf_get_lang_main no='1784.Mal Alım İrsaliyesi'></cfcase>		
            <cfcase value="761"><cf_get_lang_main no='1785.Hal İrsaliyesi'></cfcase>	
            <cfcase value="77"><cf_get_lang_main no='1786.Konsinye Giriş İrsaliyesi'></cfcase>		
            <cfcase value="78"><cf_get_lang_main no='1787.Alım İade İrsaliyesi'></cfcase>		
            <cfcase value="79"><cf_get_lang_main no='1788.Konsinye Giriş İade İrsaliyesi'></cfcase>		
            <cfcase value="80"><cf_get_lang_main no='1789.Müstahsil İrsaliyesi'></cfcase>		
            <cfcase value="81"><cf_get_lang_main no='1790.Sevk İrsaliyesi'></cfcase>			
            <cfcase value="811"><cf_get_lang_main no='1791.İthal Mal Girişi'></cfcase>	
            <cfcase value="82"><cf_get_lang_main no='1792.Demirbaş Alım İrsaliyesi'></cfcase>
            <cfcase value="83"><cf_get_lang_main no='1793.Demirbaş Satış İrsaliyesi'></cfcase>
            <cfcase value="84"><cf_get_lang_main no='405.Gider Pusulası(Mal)'></cfcase>
            <cfcase value="85"><cf_get_lang_main no='1794.Servis- Üreticiye Çıkış İrsaliyesi'></cfcase>
            <cfcase value="86"><cf_get_lang_main no='1795.Servis- Üreticiden Giriş İrsaliyesi'></cfcase>
            <cfcase value="87"><cf_get_lang_main no='1796.İthalat İrsaliyesi'></cfcase>
            <cfcase value="88"><cf_get_lang_main no='1797.İhracat İrsaliyesi'></cfcase>
            <!--- Çek Senet --->
            <cfcase value="90"><cf_get_lang_main no='440.Çek Giriş Bordrosu'></cfcase>
            <cfcase value="91"><cf_get_lang_main no='443.Çek Çıkış Bordrosu-Ciro'></cfcase>
            <cfcase value="92"><cf_get_lang_main no='441.Çek Çıkış Bordrosu-Tahsil'></cfcase>
            <cfcase value="93"><cf_get_lang_main no='1800.Çek Çıkış Bordrosu-Banka Tahsil'></cfcase>
            <cfcase value="133"><cf_get_lang_main no='442.Çek Çıkış Bordrosu (Banka Teminat)'></cfcase>
            <cfcase value="94"><cf_get_lang_main no='1798.Çek Çıkış İade Bordrosu'></cfcase>
            <cfcase value="95"><cf_get_lang_main no='1799.Çek Giriş İade Bordrosu'></cfcase>
            <cfcase value="96"><cf_get_lang_main no='1801.İşyerleri Arası Bordro(Müşteri Çekiyle)'></cfcase>
            <cfcase value="97"><cf_get_lang_main no='598.Senet Giriş Bordrosu'></cfcase>
            <cfcase value="98"><cf_get_lang_main no='1802.Senet Çıkış Bordrosu-Ciro'></cfcase>
            <cfcase value="99"><cf_get_lang_main no='1803.Senet Çıkış Bordrosu-Banka Tahsil'></cfcase>
            <cfcase value="100"><cf_get_lang_main no='1804.Senet Çıkış Bordrosu-Banka Teminat'></cfcase>
            <cfcase value="101"><cf_get_lang_main no='1805.Senet Çıkış İade Bordrosu'></cfcase>
            <cfcase value="102"><cf_get_lang_main no='1806.Senet İşlem Bordrosu (Müşteride Tahsil)'></cfcase>
            <cfcase value="103"><cf_get_lang_main no='1807.İşyerleri Arası Bordro (Müşteri Senetiyle)'></cfcase>
            <cfcase value="104"><cf_get_lang_main no='1808.Senet Çıkış Tahsil'></cfcase>
            <cfcase value="105"><cf_get_lang_main no='1799.Çek Giriş İade Bordrosu'>-<cf_get_lang_main no='109.Banka'></cfcase>
            <cfcase value="1040"><cf_get_lang_main no='1809.Çek İşlemi Tahsil Kasaya'></cfcase>
            <cfcase value="1041"><cf_get_lang_main no='1810.Çek İşlemi Ödeme Kasadan'></cfcase>
            <cfcase value="1042"><cf_get_lang_main no='1811.Çek İşlemi Masraf Kasadan'></cfcase>
            <cfcase value="1043"><cf_get_lang_main no='1812.Çek İşlemi Tahsil Bankada'></cfcase>
            <cfcase value="1044"><cf_get_lang_main no='1813.Çek İşlemi Ödeme Bankadan'></cfcase>
            <cfcase value="1045"><cf_get_lang_main no='1814.Çek İşlemi Masraf Bankadan'></cfcase>
            <cfcase value="1046"><cf_get_lang_main no='1815.Çek İşlemi-Karşılıksız Çek'></cfcase>
            <cfcase value="1050"><cf_get_lang_main no='1816.Senet İşlemi Tahsil Kasaya'></cfcase>
            <cfcase value="1051"><cf_get_lang_main no='1820.Senet İşlemi Ödeme Kasadan'></cfcase>
            <cfcase value="1052"><cf_get_lang_main no='1818.Senet İşlemi Masraf Kasadan'></cfcase>
            <cfcase value="1053"><cf_get_lang_main no='1819.Senet İşlemi Tahsil Bankaya'></cfcase>
            <cfcase value="1054"><cf_get_lang_main no='1817.Senet İşlemi Ödeme Bankadan'></cfcase>
            <cfcase value="1055"><cf_get_lang_main no='1821.Senet İşlemi Masraf Bankadan'></cfcase>
            <cfcase value="1056"><cf_get_lang_main no='1822.Senet İşlemi Karşılıksız Senet'></cfcase>
            <cfcase value="1057"><cf_get_lang_main no='1823.Senet Tahsilat İşlemi'></cfcase>
            <cfcase value="106"><cf_get_lang_main no='1824.Çek Açılış Devir'></cfcase>
            <cfcase value="107"><cf_get_lang_main no='1825.Senet Açılış Devir'></cfcase>
            <cfcase value="108"><cf_get_lang_main no='1509.Senet Giriş İade Bordrosu'></cfcase>
            <cfcase value="109"><cf_get_lang_main no='601.Senet İade Giriş Bordrosu'></cfcase>
            <cfcase value="134"><cf_get_lang_main no='1826.Çek Transfer İşlemi(Çıkış)'></cfcase>
            <cfcase value="135"><cf_get_lang_main no='1827.Çek Transfer İşlemi(Giriş)'></cfcase>
            <cfcase value="136"><cf_get_lang_main no='1828.Senet Transfer İşlemi(Çıkış)'></cfcase>
            <cfcase value="137"><cf_get_lang_main no='1829.Senet Transfer İşlemi(Giriş)'></cfcase>
            <cfcase value="2501"><cf_get_lang_main no='2782.Çek/Senet Banka Ödeme'></cfcase>
            <cfcase value="3201"><cf_get_lang_main no='2783.Çek/Senet Kasa Ödeme'></cfcase>
            <!--- Stok --->
            <cfcase value="110"><cf_get_lang_main no='1830.Üretimden Çıkış Fişi'></cfcase>
            <cfcase value="111"><cf_get_lang_main no='1831.Sarf Fişi'></cfcase>
            <cfcase value="112"><cf_get_lang_main no='1832.Fire Fişi'></cfcase>
            <cfcase value="113"><cf_get_lang_main no='1833.Ambar Fişi'></cfcase>
            <cfcase value="114"><cf_get_lang_main no='1834.Devir Fişi'></cfcase>
            <cfcase value="115"><cf_get_lang_main no='1835.Sayım Fişi'></cfcase>
            <cfcase value="116"><cf_get_lang_main no='1412.Stok Virman'></cfcase>
            <cfcase value="1161"><cf_get_lang_main no='1836.Stok Virman (Seri Geri Gelen)'></cfcase>
            <cfcase value="117"><cf_get_lang_main no='1837.Sayım Sıfırlama'></cfcase>
            <cfcase value="118"><cf_get_lang_main no='1838.Demirbaş Stok Fişi'></cfcase>
            <cfcase value="1181"><cf_get_lang_main no='1839.Demirbaş Devir Fişi'></cfcase>
            <cfcase value="1182"><cf_get_lang_main no='1840.Demirbaş Stok İade Fişi'></cfcase>
            <cfcase value="119"><cf_get_lang_main no='1841.Üretimden Giriş Fişi (Demontaj)'></cfcase>
            <cfcase value="1131"><cf_get_lang_main no='1842.Seri Sonu Stok Fişi'></cfcase>
            <cfcase value="1190"><cf_get_lang_main no='1843.Seri Aktarım Fişi'></cfcase>
            <cfcase value="1191"><cf_get_lang_main no='1844.Seri Özel Giriş'></cfcase>
            <cfcase value="1192"><cf_get_lang_main no='1845.Seri Özel Çıkış'></cfcase>
            <cfcase value="1193"><cf_get_lang_main no='1846.Sistem (Abone) Serileri'></cfcase>
            <!--- Objects --->
            <cfcase value="120"><cf_get_lang_main no='652.Masraf Fişi'></cfcase>
            <cfcase value="121"><cf_get_lang_main no='653.Gelir Fişi'></cfcase>
            <cfcase value="122"><cf_get_lang_main no='1847.Bakım Fişi'></cfcase>
            <!--- Hr --->
            <cfcase value="130"><cf_get_lang_main no='1848.Bordro İşlemleri'></cfcase>
            <cfcase value="131"><cf_get_lang_main no='1849.Toplu Dekont'></cfcase>
            <!--- Service --->
            <cfcase value="140"><cf_get_lang_main no='1850.Servis Stok Giriş Hareketi'></cfcase>
            <cfcase value="141"><cf_get_lang_main no='1851.Servis Stok Çıkış Hareketi'></cfcase>
            <!--- Project --->
            <cfcase value="150"><cf_get_lang_main no='4.Proje'></cfcase>
            <!--- Bütçe --->
            <cfcase value="160"><cf_get_lang_main no='1852.Gider Planlama Fişi'></cfcase>
            <cfcase value="161"><cf_get_lang_main no='1853.Tahakkuk Fişi'></cfcase>
            <cfcase value="162"><cf_get_lang dictionary_id='60995.Bütçe Transfer'></cfcase>
            <!--- Üretim Planlama --->
            <cfcase value="171"><cf_get_lang_main no='1854.Üretim Sonucu'></cfcase>
            <cfcase value="1194"><cf_get_lang_main no='2252.Üretim emri'></cfcase>
            <!--- Kredi ve Fon Yönetimi --->
            <cfcase value="290"><cf_get_lang_main no='1855.Kredi Sözleşmesi'></cfcase>	
            <cfcase value="291"><cf_get_lang_main no='426.Kredi Ödemesi'></cfcase>	
            <cfcase value="292"><cf_get_lang_main no='427.Kredi Tahsilatı'></cfcase>	
            <cfcase value="293"><cf_get_lang_main no='428.Menkul Kıymet Alış'></cfcase>	
            <cfcase value="294"><cf_get_lang_main no='429.Menkul Kıymet Satış'></cfcase>	
            <cfcase value="295"><cf_get_lang_main no='1856.Menkul Kıymet Değerleme'></cfcase>	
            <cfcase value="296"><cf_get_lang_main no='1857.Finansal Kredi Sözleşmesi'></cfcase>	
            <cfcase value="300"><cf_get_lang_main no='1277.Teminat'></cfcase>	
            <cfcase value="301"><cf_get_lang_main no='1858.Teminat İade'></cfcase>	
            <cfcase value="1201"><cf_get_lang dictionary_id='46609.Sağlık Harcama Fişi'></cfcase>
            <cfcase value="2503"><cf_get_lang dictionary_id='33706.Sağlık Harcaması'></cfcase>
            <cfdefaultcase></cfdefaultcase>
                            
        </cfswitch>	
        </cfsavecontent>
        <cfreturn process_type_>
    </cffunction>

	<!--- Basket şablonu ekleme ve güncelleme sayfasında kullanılıyor. Buradan taşınacak. --->
    <cffunction name="get_basket_name" returntype="any" output="false">
        <cfargument name="basket_id" type="string" required="true">
        <cfsavecontent variable="basket_name">
        <cfswitch expression="#basket_id#">
            <cfcase value="1"><cf_get_lang no='84.Satınalma Faturası'></cfcase>	
            <cfcase value="2"><cf_get_lang no='85.Satış Faturası'></cfcase>	
            <cfcase value="3"><cf_get_lang no='86.Satış Teklifi'> </cfcase>	
            <cfcase value="4"><cf_get_lang no='87.Satış Siparişi'></cfcase>	
            <cfcase value="5"><cf_get_lang no='88.Satınalma Teklifi'></cfcase>	
            <cfcase value="6"><cf_get_lang no='71.Satınalma Siparişi'></cfcase>	
            <cfcase value="7"><cf_get_lang no='89.Satınalma İç Talepleri'></cfcase>	
            <cfcase value="8"><cf_get_lang no='90.Yazışmalar İç Talepler'></cfcase>	
            <cfcase value="10"><cf_get_lang no='92.Stok Satış İrsaliyesi'></cfcase>	
            <cfcase value="31"><cf_get_lang no='747.Stok Sevk İrsaliyesi'></cfcase>						  					  
            <cfcase value="11"><cf_get_lang no='93.Stok Alım İrsaliyesi'></cfcase>	
            <cfcase value="12"><cf_get_lang no='528.Stok Fişi Ekle'></cfcase>	
            <cfcase value="13"><cf_get_lang no='95.Stok Açılış Fişi'></cfcase>	
            <cfcase value="14"><cf_get_lang no='96.Stok Satış Siparişi'></cfcase>	
            <cfcase value="15"><cf_get_lang no='98.Stok Alım Siparişi'></cfcase>	
            <cfcase value="17"><cf_get_lang no='99.Şube Alım İrsaliyesi'> </cfcase>	
            <cfcase value="18"><cf_get_lang no='100.Şube Satış Faturası'></cfcase>	
            <cfcase value="19"><cf_get_lang no='101.Şube Stok Fişi'> </cfcase>	
            <cfcase value="20"><cf_get_lang no='102.Şube Alış Faturası'></cfcase>	
            <cfcase value="21"><cf_get_lang no='103.Şube Satış İrsaliyesi'></cfcase>	
            <cfcase value="32"><cf_get_lang no='748.Şube Sevk İrsaliyesi'></cfcase>						  
            <cfcase value="24"><cf_get_lang no='443.Partner Portal Teklifler'> (<cf_get_lang_main no='36.Satış'>)</cfcase>	
            <cfcase value="25"><cf_get_lang no='77.Partner Portal Siparişler'> (<cf_get_lang_main no='36.Satış'>)</cfcase>	
            <cfcase value="26"><cf_get_lang no='107.Partner Portal Ürün Katalogları'></cfcase>	
            <cfcase value="28"><cf_get_lang no='109.Public Portal Basket'> </cfcase>	
            <cfcase value="29"><cf_get_lang no='110.Kataloglar'> </cfcase>	
            <cfcase value="33"><cf_get_lang_main no='411.Müstahsil Makbuzu'></cfcase>	
            <cfcase value="34"><cf_get_lang no='760.Bütçe Satış Kotaları'></cfcase>	
            <cfcase value="35"><cf_get_lang no='820.Partner Portal(Alım) Siparişleri'></cfcase>	
            <cfcase value="36"><cf_get_lang no='821.Partner Portal(Alım) Teklifleri'></cfcase>						  					  
            <cfcase value="38"><cf_get_lang no='758.Sube Satış Siparişi'></cfcase>	
            <cfcase value="37"><cf_get_lang no='832.Sube Alım Siparişi'></cfcase>	
            <cfcase value="39"><cf_get_lang no='314.Şube İç Talepler'></cfcase>	
            <cfcase value="40"><cf_get_lang no='348.Stok Hal İrsaliyesi'></cfcase>	
            <cfcase value="41"><cf_get_lang no='356.Şube Hal İrsaliyesi'></cfcase>	
            <cfcase value="42"><cf_get_lang_main no='407.Hal Faturası'></cfcase>	
            <cfcase value="43"><cf_get_lang no='422.Şube Hal Faturası'></cfcase>	
            <cfcase value="44"><cf_get_lang no='475.Sevk İç Talep'></cfcase>	
            <cfcase value="45"><cf_get_lang no='498.Sevk İç Talep'></cfcase>	
            <cfcase value="46"><cf_get_lang_main no='1420.Abone'></cfcase>	
            <cfcase value="47"><cf_get_lang no='1055.Servis Giriş'></cfcase>	
            <cfcase value="48"><cf_get_lang no='1056.Servis Çıkış'></cfcase>					  
            <cfcase value="49"><cf_get_lang_main no='1791.İthal Mal Girişi'></cfcase>					  
            <cfcase value="50"><cf_get_lang no='1465.Proje Malzeme Planı'></cfcase>	
            <cfcase value="51"><cf_get_lang no='1588.Taksitli Satış'></cfcase>					  
            <cfcase value="52"><cf_get_lang_main no='1026.Z Raporu'></cfcase>			
            <cfdefaultcase></cfdefaultcase>
                            
        </cfswitch>	
        </cfsavecontent>
        <cfreturn basket_name>
    </cffunction>

	<!--- Özellikle rapor modülünde kullanılıyor. Değişken atamaları yapılırken bazen birim adı üzerinden atama yapılıyor. Türkçe karakterler sorun yaratıyordu. Bu yüzden oluşturuldu. --->
    <cffunction name="filterSpecialChars" access="public">
        <cfargument name="text">
        <cfset list="#chr(176)#,#chr(178)#,#chr(179)#,/, ,.,%,',(,),Ç,ç,İ,-,ü,ğ,ı,ş,ö,Ü,Ğ,Ş,Ö,|,\,&,?"><!--- #chr(176)#-Santigrat,#chr(178)#-Kare,#chr(179)#-Küp --->
        <cfset list_ = '"'>
        <cfset list2="o,2,3, , , , , , , ,C,c,I, ,u,g,i,s,o,U,G,S,O, , ">
        <cfset text = replacelist(replacelist(text,list,list2),list_,'')>
        <cfset text = replace(text,' ','','all')>
        <cfset text = replace(text,',','','all')>
        <cfreturn text>
    </cffunction>

	<!--- Objects2 tarafında kullanılıyor. Kaldırılmalı.--->
	<!--- Üst iş  bağlantısı için tarih bağlantıları--->
    <cffunction name="setWork" access="public">
        <cfargument name="fncwork_id">
        <cfquery name="get_milestone_wrkid" datasource="#dsn#">
            SELECT MILESTONE_WORK_ID,TARGET_START,TARGET_FINISH FROM PRO_WORKS WHERE WORK_ID=#fncwork_id#
        </cfquery>
        <cfif isdefined("get_milestone_wrkid.milestone_work_id") and len(get_milestone_wrkid.milestone_work_id)>
            <cfquery name="get_date" datasource="#dsn#">
                SELECT TARGET_START,TARGET_FINISH,DATEDIFF("D",TARGET_START,TARGET_FINISH)AS FARK FROM PRO_WORKS  WHERE WORK_ID=#get_milestone_wrkid.milestone_work_id#
            </cfquery>
            <cfset UST_IS_BAS=dateformat(get_date.target_start)>
            <cfset UST_IS_BIT=dateformat(get_date.target_finish)>
            <cfset IS_BAS=dateformat(get_milestone_wrkid.target_start)>
            <cfset IS_BIT=dateformat(get_milestone_wrkid.target_finish)>
            <cfif datediff('d',ust_is_bas,is_bas) lt 0  or datediff('d',is_bit,ust_is_bit) lt 0>
                <cfif datediff('d',UST_IS_BAS,IS_BIT) lt 0>
                    <cfquery name="set_date" datasource="#dsn#">
                        UPDATE PRO_WORKS SET TARGET_START=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#IS_BAS#">  where WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_milestone_wrkid.milestone_work_id#">
                    </cfquery>
                <cfelseif datediff('d',IS_BAS,UST_IS_BIT) lt 0>
                    <cfquery name="set_date" datasource="#dsn#">
                        UPDATE PRO_WORKS SET TARGET_FINISH=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#IS_BIT#"> where WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_milestone_wrkid.milestone_work_id#">
                    </cfquery>
                <cfelseif datediff('d',UST_IS_BAS,IS_BAS) lt 0 and datediff('d',IS_BIT,UST_IS_BIT) lt 0>
                    <cfquery name="set_date" datasource="#dsn#">
                        UPDATE PRO_WORKS SET TARGET_START=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#IS_BAS#">,TARGET_FINISH=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#IS_BIT#"> where WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_milestone_wrkid.milestone_work_id#">
                    </cfquery>
                <cfelseif datediff('d',UST_IS_BAS,IS_BAS) lt 0>
                    <cfquery name="set_date" datasource="#dsn#">
                        UPDATE PRO_WORKS SET TARGET_START=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#IS_BAS#"> where WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_milestone_wrkid.milestone_work_id#">
                    </cfquery>
                <cfelseif datediff('d',IS_BIT,UST_IS_BIT) lt 0>
                    <cfquery name="set_date" datasource="#dsn#">
                        UPDATE PRO_WORKS SET TARGET_FINISH=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#IS_BIT#">  where WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_milestone_wrkid.milestone_work_id#">
                    </cfquery>	
                </cfif>
            </cfif>
        </cfif>
    </cffunction>

	<!--- AES (gelişmiş sifreleme standardı) mantıgı ile 128 bit ve üzeri şifreleme FA 08102013 --->
    <!--- Şifreleme fonksiyonu --->
    <cffunction name="contentEncryptingandDecodingAES" access="public" returntype="string" hint="Generates the Base64 encoded encryption" output="false">
        <cfargument name="isEncode" type="numeric" required="false" default="1"  />
        <cfargument name="content" type="string" required="true" />
        <cfargument name="accountKey" type="string" required="true" />
        <cfargument name="apiKey1" type="string" required="false" default="" />
        <cfargument name="apiKey2" type="string" required="false" default="" />
        <cfargument name="apiKey3" type="string" required="false" default="" />
        <cfsavecontent variable="message">
            <cf_get_lang dictionary_id="52126">\n
            <cf_get_lang dictionary_id="52153">
        </cfsavecontent>
        
        
        
        <cfscript>
        
            try{
                var salted = arguments.accountKey & arguments.apiKey1 & arguments.apiKey2 & arguments.apiKey3;
                var hashed = binaryDecode(hash(salted, "sha"), "hex");
                var trunc = arrayNew(1);
                var i = 1;
                for (i = 1; i <= 16; i ++) {
                    trunc[i] = hashed[i];
                }
                var generateKey = binaryEncode(javaCast("byte[]", trunc), "Base64");
                
                if(arguments.isEncode eq 1)
                    return encrypt(arguments.content, generateKey, "AES/CBC/PKCS5Padding", "hex");
                else if(arguments.isEncode eq 0)
                    return decrypt(arguments.content, generateKey, "AES/CBC/PKCS5Padding", "hex");
            }
            catch(any e)
            {
               
                abort(message);	                 
            }
        </cfscript>
    </cffunction>

	<!--- Module ID'ye göre power user kontrolüne bakıyor. --->
    <cffunction name="get_module_power_user" returntype="string" output="false">
        <cfargument name="module_id" required="no" type="numeric">
        <cfif isDefined('arguments.module_id')>
			<cfset yetki_kodu_ = listFindNoCase(session.ep.power_user_level_id,arguments.module_id)>
        <cfelse>
            <cfset yetki_kodu_ = 0>
        </cfif>
        <cfreturn yetki_kodu_>
    </cffunction>
    
	<!--- Module ID'ye göre yetki kontrolüne bakıyor. --->
    <cffunction name="get_module_user" returntype="string" output="false">
        <cfargument name="module_id" required="no" type="numeric">
        <cfif isDefined('arguments.module_id')>
			<cfset yetki_kodu_ = listFindNoCase(session.ep.user_level,arguments.module_id)>
        <cfelse>
            <cfset yetki_kodu_ = 0>
        </cfif>
        <cfreturn yetki_kodu_>
    </cffunction>

	<!--- Kullanılıyor. --->
    <cffunction name="yerles" returntype="string" output="false">
    	<cfargument name="str_1" required="no">
        <cfargument name="str_2" required="no">
        <cfargument name="start" required="no">
        <cfargument name="width" required="no">
        <cfargument name="fill_str" required="no">
        <cfscript>
			yerles_str = left(str_1,start-1) & str_2 & repeatString(fill_str, width-len(str_2));
			if (len(str_1)-start-width+1)
				yerles_str = yerles_str & right(str_1,len(str_1)-start-width+1);
		</cfscript>
        <cfreturn yerles_str>
    </cffunction>

	<!--- Kullanılıyor. --->
    <cffunction name="yerles_saga" returntype="string" output="false">
    	<cfargument name="str_1" required="no">
        <cfargument name="str_2" required="no">
        <cfargument name="start" required="no">
        <cfargument name="width" required="no">
        <cfargument name="fill_str" required="no">
        <cfscript>
			// verilen string in start noktasından itibaren SAGA dayalı olarak yollanan stringi yazar
			// insert değil overwrite yapar
			if(start eq 1)
				yerles_str = repeatString(fill_str, width-len(str_2)) & str_2;
			else
				yerles_str = left(str_1,start-1) & repeatString(fill_str, width-len(str_2)) & str_2;
			if (len(str_1)-start-width+1)
				yerles_str = yerles_str & right(str_1,len(str_1)-start-width+1);
		</cfscript>
        <cfreturn yerles_str>
    </cffunction>

	<!--- Kullanılıyor. String'in başlangıç noktasından boşlukları temizler. --->
    <cffunction name="oku" returntype="string" output="false">
    	<cfargument name="str_1" required="no">
        <cfargument name="start" required="no">
        <cfargument name="width" required="no">
        <cfreturn Trim(Mid(str_1,start,width))/>
    </cffunction>

	<!--- Küçük harfleri büyütüyoruz. --->
    <cffunction name="UCASETR" returntype="string" output="false">
    	<cfargument name="attributes_list" required="yes">
        <cfscript>
			var return_value = '';
			return_value = replacelist(attributes_list,'a,b,c,ç,d,e,f,g,ğ,h,ı,i,j,k,l,m,n,o,ö,p,r,s,ş,t,u,ü,v,w,y,z,q,x','A,B,C,Ç,D,E,F,G,Ğ,H,I,İ,J,K,L,M,N,O,Ö,P,R,S,Ş,T,U,Ü,V,W,Y,Z,Q,X');
		</cfscript>
        <cfreturn return_value>
    </cffunction>

	<!--- Büyük harfleri küçültüyoruz. --->
    <cffunction name="LCASETR" returntype="string" output="false">
    	<cfargument name="attributes_list" required="yes">
        <cfscript>
			var return_value = '';
			return_value = replacelist(attributes_list,'A,B,C,Ç,D,E,F,G,Ğ,H,I,İ,J,K,L,M,N,O,Ö,P,R,S,Ş,T,U,Ü,V,W,Y,Z,Q,X','a,b,c,ç,d,e,f,g,ğ,h,ı,i,j,k,l,m,n,o,ö,p,r,s,ş,t,u,ü,v,w,y,z,q,x');
		</cfscript>
        <cfreturn return_value>
    </cffunction>


	<!--- Struct array'e dönüştürülüyor. --->
    <cffunction name="structToList" returntype="string" output="false">
    	<cfargument name="s" required="yes">
        <cfargument name="delim" required="no" default="&">
        <cfscript>
			var i = 0;
			var newArray = structKeyArray(arguments.s);
		
			if (arrayLen(arguments) gt 1) delim = arguments.delim;
		
			for(i=1;i lte structCount(arguments.s);i=i+1) newArray[i] = newArray[i] & "=" & arguments.s[newArray[i]];
		</cfscript>
        <cfreturn arraytoList(newArray,delim)>
    </cffunction>
    
    <!--- get_basket_money_js.cfm --->
	<cffunction name="session_basket_kur_ekle">
        <!---
            by : 20031211
            notes : session da islemlere gore kur bilgisini gosterir.
            usage :
                process_type:1 upd 0 add
                invoice:1
                ship:2
                order:3
                offer:4
                servis:5
                stock_fis:6
                internmal_demand:7
                prroduct_catalog 8
                sale_quote:9
                subscription:13
            revisions : javascript version 20040209
        --->
        <cfargument name="action_id">
        <cfargument name="table_type_id">
        <cfargument name="to_table_type_id"> <!---belge baska bir belgeye cekiliyorsa (irsaliyenin faturaya cekilmesi gibi) bu parametre gonderilir.  --->
        <cfargument name="process_type" required="true">
        <cfif IsDefined("session.wp")>
            <cfset int_bsk_comp_id = SESSION.WP.COMPANY_ID>
            <cfset int_bsk_period_id = SESSION.WP.PERIOD_ID>
            <cfset str_money_bskt_func=SESSION.WP.MONEY>
            <cfset int_bsk_period_year=SESSION.WP.PERIOD_YEAR>
        <cfelse>
            <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                <cfset int_bsk_comp_id = SESSION.EP.COMPANY_ID>
                <cfset int_bsk_period_id = SESSION.EP.PERIOD_ID>
                <cfset str_money_bskt_func=SESSION.EP.MONEY>
                <cfset int_bsk_period_year=SESSION.EP.PERIOD_YEAR>
            <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                <cfset int_bsk_comp_id = SESSION.PP.OUR_COMPANY_ID>
                <cfset int_bsk_period_id = SESSION.PP.PERIOD_ID>
                <cfset str_money_bskt_func=SESSION.PP.MONEY>
                <cfset int_bsk_period_year=SESSION.PP.PERIOD_YEAR>
            <cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>
                <cfset int_bsk_comp_id = SESSION.WW.OUR_COMPANY_ID>
                <cfset int_bsk_period_id = SESSION.WW.PERIOD_ID>
                <cfset str_money_bskt_func=SESSION.WW.MONEY>
                <cfset int_bsk_period_year=SESSION.WW.PERIOD_YEAR>
            <cfelseif listfindnocase(pda_url,'#cgi.http_host#',';')>
                <cfset int_bsk_comp_id = SESSION.PDA.OUR_COMPANY_ID>
                <cfset int_bsk_period_id = SESSION.PDA.PERIOD_ID>
                <cfset str_money_bskt_func=SESSION.PDA.MONEY>
                <cfset int_bsk_period_year=SESSION.PDA.PERIOD_YEAR>
            </cfif>
        </cfif>
        
        <cfquery name="get_standart_process_money" datasource="#dsn#">  <!--- muhasebe doneminden standart islem dövizini alıyor --->
            SELECT STANDART_PROCESS_MONEY FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_period_id#">
        </cfquery>
        <cfif arguments.process_type eq 1>
            <cfscript>
                switch (arguments.table_type_id)
                {
                    case 1: fnc_table_name="INVOICE_MONEY"; fnc_dsn_name="#dsn2#";break;
                    case 2: fnc_table_name="SHIP_MONEY"; fnc_dsn_name="#dsn2#"; break;
                    case 3: fnc_table_name="ORDER_MONEY"; fnc_dsn_name="#dsn3#"; break;
                    case 4: fnc_table_name="OFFER_MONEY"; fnc_dsn_name="#dsn3#"; break;
                    case 5: fnc_table_name="SERVICE_MONEY"; fnc_dsn_name="#dsn3#";break;
                    case 6: fnc_table_name="STOCK_FIS_MONEY"; fnc_dsn_name="#dsn2#"; break;
                    case 7: fnc_table_name="INTERNALDEMAND_MONEY"; fnc_dsn_name="#dsn3#"; break;
                    case 8: fnc_table_name="CATALOG_MONEY"; fnc_dsn_name="#dsn3#"; break;
                    case 10: fnc_table_name="SHIP_INTERNAL_MONEY"; fnc_dsn_name="#dsn2#"; break;
                    case 11: fnc_table_name="PAYROLL_MONEY"; fnc_dsn_name="#dsn2#"; break;
                    case 12: fnc_table_name="VOUCHER_PAYROLL_MONEY"; fnc_dsn_name="#dsn2#"; break;
                    case 13: fnc_table_name="SUBSCRIPTION_CONTRACT_MONEY"; fnc_dsn_name="#dsn3#"; break;				
                    case 14: fnc_table_name="PRO_MATERIAL_MONEY"; fnc_dsn_name="#dsn#"; break;			
                }
                is_rate_from_pre_paper_ =1; /*belge kurunu bir önceki belgeden alır.*/
            </cfscript>
            <cfif isdefined('arguments.to_table_type_id') and arguments.to_table_type_id neq arguments.table_type_id> 
                <cfquery name="control_comp_rate_type" datasource="#dsn#">
                    SELECT IS_RATE_FROM_PRE_PAPER FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#">
                </cfquery>
                <cfif len(control_comp_rate_type.IS_RATE_FROM_PRE_PAPER) and control_comp_rate_type.IS_RATE_FROM_PRE_PAPER eq 0>
                    <cfset is_rate_from_pre_paper_ = 0>
                </cfif>
            </cfif>
            <cfif is_rate_from_pre_paper_> <!--- belgenin kuru bir önceki belgeden alınır veya kendi kur bilgisi getirilir--->
                <cfquery name="get_money_bskt" datasource="#fnc_dsn_name#">
                    SELECT 
                        <cfif int_bsk_period_year gte 2009>
                            CASE WHEN MONEY_TYPE ='YTL' THEN '<cfoutput>#str_money_bskt_func#</cfoutput>' ELSE MONEY_TYPE END AS MONEY_TYPE,
                        <cfelseif fnc_dsn_name is dsn3>
                            CASE WHEN MONEY_TYPE ='TL' THEN '<cfoutput>#str_money_bskt_func#</cfoutput>' ELSE MONEY_TYPE END AS MONEY_TYPE,
                        <cfelse>
                            MONEY_TYPE,
                        </cfif> 
                        ACTION_ID,
                        RATE2,
                        RATE1,
                        IS_SELECTED
                    FROM 
                        #fnc_table_name# 
                    WHERE 
                        ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                    ORDER BY ACTION_MONEY_ID
                </cfquery>
                <cfif not get_money_bskt.recordcount>
                    <cfquery name="get_money_bskt" datasource="#dsn#">
                        SELECT 
                            MONEY AS MONEY_TYPE,0 AS IS_SELECTED,* 
                        FROM 
                            SETUP_MONEY 
                        WHERE 
                            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#">
                            AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_period_id#">
                            AND MONEY_STATUS=1 
                        ORDER BY MONEY_ID
                    </cfquery>
                </cfif>
            <cfelse>
                <cfquery name="get_comp_info" datasource="#dsn#">
                    SELECT ISNULL(IS_SELECT_RISK_MONEY,0) IS_SELECT_RISK_MONEY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#">
                </cfquery>
                <cfif get_comp_info.is_select_risk_money eq 1 and isdefined("attributes.comp_id") and len(attributes.comp_id)  and ((attributes.fuseaction is 'stock.form_add_sale' and isdefined("attributes.order_id"))  or  (attributes.fuseaction is 'purchase.add_product_all_order') or (attributes.fuseaction is 'invoice.form_add_bill' and isdefined("url.order_id")) or (attributes.fuseaction is 'invoice.form_add_bill' and isdefined("url.ship_id")) or (attributes.fuseaction is 'sales.list_order' and (isdefined("attributes.event") and attributes.event is 'add') and (isdefined("url.order_id") or isdefined("url.offer_id"))))>
                    <cfquery name="get_comp_credit" datasource="#dsn#">
                        SELECT PAYMENT_RATE_TYPE,MONEY FROM COMPANY_CREDIT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#"> AND COMPANY_CREDIT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#">
                    </cfquery>
                    <cfelseif get_comp_info.is_select_risk_money eq 1 and isdefined("attributes.cons_id") and len(attributes.cons_id)  and ((attributes.fuseaction is 'stock.form_add_sale' and isdefined("attributes.order_id") )  or (attributes.fuseaction is 'purchase.add_product_all_order') or (attributes.fuseaction is 'invoice.form_add_bill' and isdefined("url.order_id")) or (attributes.fuseaction is 'invoice.form_add_bill' and isdefined("url.ship_id")) or (attributes.fuseaction is 'sales.list_order' and (isdefined("attributes.event") and attributes.event is 'add') and (isdefined("url.order_id") or isdefined("url.offer_id"))))>
                    <cfquery name="get_comp_credit" datasource="#dsn#">
                        SELECT PAYMENT_RATE_TYPE,MONEY FROM COMPANY_CREDIT WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#"> AND COMPANY_CREDIT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#">
                    </cfquery>
                </cfif>
                <cfquery name="get_pre_paper_money" datasource="#fnc_dsn_name#"><!--- onceki belgede secili olan doviz birimi alınıyor --->
                    SELECT 
                        <cfif int_bsk_period_year gte 2009>
                            CASE WHEN MONEY_TYPE ='YTL' THEN '<cfoutput>#str_money_bskt_func#</cfoutput>' ELSE MONEY_TYPE END AS MONEY_TYPE
                        <cfelseif fnc_dsn_name is dsn3>
                            CASE WHEN MONEY_TYPE ='TL' THEN '<cfoutput>#str_money_bskt_func#</cfoutput>' ELSE MONEY_TYPE END AS MONEY_TYPE
                        <cfelse>
                            MONEY_TYPE
                        </cfif> 
                    FROM 
                        #fnc_table_name# 
                    WHERE 
                        ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                        AND IS_SELECTED=1
                </cfquery>
                <cfif get_pre_paper_money.recordcount and len(get_pre_paper_money.MONEY_TYPE)>
                    <cfset pre_paper_money=get_pre_paper_money.MONEY_TYPE>
                <cfelse>
                    <cfset pre_paper_money=''>
                </cfif>
                <cfquery name="get_money_bskt" datasource="#dsn#">
                    SELECT 
                        MONEY AS MONEY_TYPE,
                        <cfif isdefined("get_comp_credit") and get_comp_credit.recordcount>
                            <cfif get_comp_credit.payment_rate_type eq 1>
                                ISNULL(RATE3,1) RATE2,
                            <cfelseif get_comp_credit.payment_rate_type eq 3>
                                ISNULL(EFFECTIVE_PUR,1) RATE2,
                            <cfelseif get_comp_credit.payment_rate_type eq 4>
                                ISNULL(EFFECTIVE_SALE,RATE2) RATE2,
                            <cfelse>
                                RATE2 RATE2,
                            </cfif>
                        <cfelse>
                            RATE2,
                        </cfif>
                        RATE1,
                        <cfif len(pre_paper_money)><!--- kur onceki belgeden alınmıyor, fakat secili olan işlem dovizi onceki belgeden getiriliyor --->
                            CASE WHEN MONEY ='<cfoutput>#pre_paper_money#</cfoutput>' THEN 1 ELSE 0 END AS IS_SELECTED,
                        <cfelse>
                             0 AS IS_SELECTED,
                        </cfif>
                        * 
                    FROM 
                        SETUP_MONEY 
                    WHERE
                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#">
                        AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_period_id#">
                        AND MONEY_STATUS=1 
                    ORDER BY MONEY_ID
                </cfquery>
            </cfif>
        <cfelse>
            <cfquery name="get_comp_info" datasource="#dsn#">
                SELECT ISNULL(IS_SELECT_RISK_MONEY,0) IS_SELECT_RISK_MONEY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#">
            </cfquery>
            <cfif get_comp_info.is_select_risk_money eq 1 and isdefined("attributes.comp_id") and len(attributes.comp_id) and (attributes.fuseaction is 'purchase.add_product_all_order' or attributes.fuseaction is 'invoice.add_sale_invoice_from_order' or attributes.fuseaction is 'invoice.form_add_bill_from_ship' or (attributes.fuseaction is 'sales.form_add_order' and isdefined("attributes.upd_order")) or (attributes.fuseaction is 'stock.form_add_sale'  and isdefined("attributes.service_ids")) or (attributes.fuseaction is 'sales.list_order' and (isdefined("attributes.event") and attributes.event is 'add')) or (attributes.fuseaction is 'purchase.list_order' and (isdefined("attributes.event") and attributes.event is 'add')) or (attributes.fuseaction is 'sales.list_offer' and (isdefined("attributes.event") and attributes.event is 'add')) or (attributes.fuseaction is 'sales.list_order_instalment' and (isdefined("attributes.event") and attributes.event is 'add')) or (attributes.fuseaction is 'invoice.form_add_bill') or (attributes.fuseaction is 'invoice.form_add_bill_purchase') )>
                <cfquery name="get_comp_credit" datasource="#dsn#">
                    SELECT PAYMENT_RATE_TYPE,MONEY FROM COMPANY_CREDIT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#"> AND COMPANY_CREDIT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#">
                </cfquery>
            <cfelseif get_comp_info.is_select_risk_money eq 1 and isdefined("attributes.cons_id") and len(attributes.cons_id) and (attributes.fuseaction is 'sales.list_offer' or attributes.fuseaction is 'sales.list_order' or (attributes.fuseaction is 'stock.form_add_sale' and isdefined("attributes.order_id") )  or attributes.fuseaction is 'purchase.add_product_all_order' or (attributes.fuseaction is 'invoice.form_add_bill' and isdefined("url.order_id")) or (attributes.fuseaction is 'invoice.form_add_bill' and isdefined("url.ship_id")) or (attributes.fuseaction is 'sales.list_order' and (isdefined("attributes.event") and attributes.event is 'add'))  or (attributes.fuseaction is 'sales.form_add_order' and isdefined("attributes.upd_order")) or  (attributes.fuseaction is 'stock.form_add_sale'  and isdefined("attributes.service_ids")) )>
                <cfquery name="get_comp_credit" datasource="#dsn#">
                    SELECT PAYMENT_RATE_TYPE,MONEY FROM COMPANY_CREDIT WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#"> AND COMPANY_CREDIT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#">
                </cfquery>
            </cfif>
            <cfquery name="get_money_bskt" datasource="#dsn#">
                SELECT
                    MONEY AS MONEY_TYPE,
                    RATE1,
                    <cfif isDefined("session.pp")>
                        RATEPP2 RATE2,
                    <cfelseif isDefined("session.ww")>
                        RATEWW2 RATE2,
                    <cfelse>
                        <cfif isdefined("get_comp_credit") and get_comp_credit.recordcount>
                            <cfif get_comp_credit.payment_rate_type eq 1>
                                RATE3 RATE2,
                            <cfelseif get_comp_credit.payment_rate_type eq 3>
                                ISNULL(EFFECTIVE_PUR,1) RATE2,
                            <cfelseif get_comp_credit.payment_rate_type eq 4>
                                ISNULL(EFFECTIVE_SALE,1) RATE2,
                            <cfelse>
                                RATE2 RATE2,
                            </cfif>
                        <cfelse>
                            RATE2,
                        </cfif>
                    </cfif>
                    <cfif isdefined("get_comp_credit") and get_comp_credit.recordcount>
                        CASE WHEN MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_comp_credit.MONEY#"> THEN 1 ELSE 0 END AS IS_SELECTED
                    <cfelse>
                        0 AS IS_SELECTED
                    </cfif>
                FROM
                    SETUP_MONEY
                WHERE
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#"> AND
                    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_period_id#"> AND
                    MONEY_STATUS = 1
                ORDER BY CASE MONEY WHEN 'TL' THEN 1 ELSE 2 END
            </cfquery>
        </cfif>        
        <script language="JavaScript1.3">
            moneyArray = new Array(<cfoutput>#get_money_bskt.recordcount#</cfoutput>);
            rate1Array = new Array(<cfoutput>#get_money_bskt.recordcount#</cfoutput>);
            rate2Array = new Array(<cfoutput>#get_money_bskt.recordcount#</cfoutput>);
            <cfoutput query="get_money_bskt">
                /*javascript array doldurulur*/
                <cfif int_bsk_period_year gte 2009 and get_money_bskt.MONEY_TYPE is 'YTL'>
                    moneyArray[#currentrow-1#] = '#str_money_bskt_func#';
                <cfelse>
                    moneyArray[#currentrow-1#] = '#MONEY_TYPE#';
                </cfif>
                rate1Array[#currentrow-1#] = #rate1#;
                rate2Array[#currentrow-1#] = #rate2#;
                /*javascript array doldurulur*/
            </cfoutput>
        </script>
    </cffunction>
    
    <cffunction name="basket_kur_ekle">
        <cfargument name="action_id" required="true">
        <cfargument name="table_type_id" required="true">
        <cfargument name="process_type" required="true">
        <cfargument name="basket_money_db" type="string" default="">
        <cfargument name="transaction_dsn">
        <!---
            by : Arzu BT 20031211
            notes : Basket_money tablosuna islemlere gore kur bilgilerini kaydeder.
            process_type:1 upd 0 add
            transaction_dsn : kullanılan sayfa içinde table dan farklı dsn tanımı olduğu durumlarda kullanılan dsn gönderilir.
            usage :
                invoice:1
                ship:2
                order:3
                offer:4
                servis:5
                stock_fis:6
                internmal_demand:7
                prroduct_catalog 8
                sale_quote:9
                subscription:13
            revisions : javascript version ergün koçak 20040209
            kullanim:
            <cfscript>
                basket_kur_ekle(action_id:MY_ID,table_type_id:1,process_type:0);
            </cfscript>		
        --->
        <cfscript>
            switch (arguments.table_type_id){
                case 1: fnc_table_name="INVOICE_MONEY"; fnc_dsn_name="#dsn2#";break;
                case 2: fnc_table_name="SHIP_MONEY"; fnc_dsn_name="#dsn2#"; break;
                case 3: fnc_table_name="ORDER_MONEY"; fnc_dsn_name="#dsn3#"; break;
                case 4: fnc_table_name="OFFER_MONEY"; fnc_dsn_name="#dsn3#"; break;
                case 5: fnc_table_name="SERVICE_MONEY"; fnc_dsn_name="#dsn3#";break;
                case 6: fnc_table_name="STOCK_FIS_MONEY"; fnc_dsn_name="#dsn2#"; break;
                case 7: fnc_table_name="INTERNALDEMAND_MONEY"; fnc_dsn_name="#dsn3#"; break;
                case 8: fnc_table_name="CATALOG_MONEY"; fnc_dsn_name="#dsn3#"; break;
                case 10: fnc_table_name="SHIP_INTERNAL_MONEY"; fnc_dsn_name="#dsn2#"; break;	
                case 11: fnc_table_name="PAYROLL_MONEY"; fnc_dsn_name="#dsn2#"; break;
                case 12: fnc_table_name="VOUCHER_PAYROLL_MONEY"; fnc_dsn_name="#dsn2#"; break;
                case 13: fnc_table_name="SUBSCRIPTION_CONTRACT_MONEY"; fnc_dsn_name="#dsn3#"; break;			
                case 14: fnc_table_name="PRO_MATERIAL_MONEY"; fnc_dsn_name="#dsn#"; break;
            }
            if(len(arguments.basket_money_db))fnc_dsn_name = "#arguments.basket_money_db#";
        </cfscript>
        <cfif not (isdefined('arguments.transaction_dsn') and len(arguments.transaction_dsn))>
            <cfset arguments.transaction_dsn = fnc_dsn_name>
            <cfset arguments.action_table_dsn_alias = ''>
        <cfelse>
            <cfset arguments.action_table_dsn_alias = '#fnc_dsn_name#.'>
        </cfif>
        <cfif arguments.process_type eq 1>
            <cfquery name="del_money_obj_bskt" datasource="#arguments.transaction_dsn#">
                DELETE FROM 
                    #arguments.action_table_dsn_alias##fnc_table_name#
                WHERE 
                    ACTION_ID=#arguments.action_id#
            </cfquery>
        </cfif>
        <cfloop from="1" to="#attributes.kur_say#" index="fnc_i">
            <cfquery name="add_money_obj_bskt" datasource="#arguments.transaction_dsn#">
                INSERT INTO #arguments.action_table_dsn_alias##fnc_table_name# 
                (
                    ACTION_ID,
                    MONEY_TYPE,
                    RATE2,
                    RATE1,
                    IS_SELECTED
                )
                VALUES
                (
                    #arguments.action_id#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.hidden_rd_money_#fnc_i#')#">,
                    #evaluate("attributes.txt_rate2_#fnc_i#")#,
                    #evaluate("attributes.txt_rate1_#fnc_i#")#,
                    <cfif evaluate("attributes.hidden_rd_money_#fnc_i#") is attributes.BASKET_MONEY>
                        1
                    <cfelse>
                        0
                    </cfif>					
                )
            </cfquery>
        </cfloop>
    </cffunction>
	<!--- get_basket_money_js.cfm --->
    
    <!--- get_cost.cfm --->
    <cffunction name="get_cost_info" returntype="string" output="false">
    <!---
        by : TolgaS 20061110
        notes : 
            .....URUN, SPEC VEYA AGAC MALIYETINI LISTE SEKLINDE PURCHASE_NET_SYSTEM PARA TURUNDEN BULUR .....
        usage :
        sadece main_spec_id den degerler alinarak kaydedilecekse
            get_cost_info(
                    stock_id: ,
                    main_spec_id: ,
                    spec_id: ,
                    cost_date: ,
                    is_purchasesales:
                );
        --->
        <cfargument name="stock_id" type="numeric" required="yes"><!--- maliyeti bulunacak stock_id stock_id cunku stock_id bazında agac--->
        <cfargument name="main_spec_id" type="numeric" required="no"><!--- main_spec id icerigine gore maliyeti bulur bu deger varsa spec_id gerek yok --->
        <cfargument name="spec_id" type="numeric" required="no"><!--- spec_id bundan maın_spec_id bulunarak maliyeti hesaplanır --->
        <cfargument name="cost_date" type="date" required="no" default="#now()#"><!--- maliyet bulunacak tarih --->
        <cfargument name="dsn_type" type="string" required="no" default="#dsn3#"><!--- olurda cftransaction icinde olursa diye dsn yollansın --->
        <cfargument name="is_purchasesales" type="boolean" required="no" default="1"><!--- alis (0) veya satis(1) tipi. alis tipinde alis fiyatini getirir --->
    
        <cfif not len(arguments.cost_date) gt 9><cfset arguments.cost_date=now()></cfif>
        <cf_date tarih='cost_date'>
        <cfscript>
        maliyet_id=0;
        toplam_maliyet_sistem = 0;
        toplam_maliyet_extra_sistem = 0;
        GET_PROD=cfquery(SQLString:'SELECT IS_COST,PRODUCT_ID FROM #dsn3_alias#.STOCKS STOCKS WHERE STOCK_ID = #arguments.stock_id#',Datasource:'#dsn_type#',is_select:1);
        if(len(GET_PROD.IS_COST) and GET_PROD.IS_COST eq 1)
        {
            if(is_purchasesales eq 1)
            {
                if(isdefined('arguments.spec_id') and len(arguments.spec_id))
                {
                    GET_MAIN_SPEC=cfquery(SQLString:'SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID=#arguments.spec_id#',Datasource:'#dsn_type#',is_select:1);
                    if(GET_MAIN_SPEC.RECORDCOUNT) arguments.main_spec_id=GET_MAIN_SPEC.SPECT_MAIN_ID;
                }
                if(isdefined('arguments.main_spec_id') and len(arguments.main_spec_id))
                {
                    GET_SPEC_ROW=cfquery(SQLString:'SELECT PRODUCT_ID, STOCK_ID, AMOUNT FROM SPECT_MAIN_ROW WHERE SPECT_MAIN_ID=#arguments.main_spec_id# AND PRODUCT_ID IS NOT NULL AND IS_PROPERTY=0',Datasource:'#dsn_type#',is_select:1);//sadece sarfları aldık fireler maliyette etki etmeyecek diye düsünüldü ama degise bilir
                    cost_info_product_list=listsort(valuelist(GET_SPEC_ROW.PRODUCT_ID,','),'Numeric');
                    if(listlen(cost_info_product_list) eq 0)cost_info_product_list=0;
                    GET_COST_ALL=cfquery(SQLString:'SELECT PRODUCT_ID, PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM, START_DATE, RECORD_DATE FROM #dsn3_alias#.PRODUCT_COST PRODUCT_COST WHERE START_DATE <= #arguments.cost_date# AND PRODUCT_ID IN(#cost_info_product_list#)',Datasource:'#dsn_type#',is_select:1);
                    for(ww=1;ww lte GET_SPEC_ROW.RECORDCOUNT;ww=ww+1)
                    {
                        GET_TREE=cfquery(SQLString:"SELECT PRODUCT_TREE.RELATED_ID,PRODUCT_TREE.AMOUNT,STOCKS.PRODUCT_ID FROM PRODUCT_TREE,STOCKS WHERE PRODUCT_TREE.PRODUCT_ID IS NOT NULL AND PRODUCT_TREE.STOCK_ID = #evaluate('GET_SPEC_ROW.STOCK_ID[#ww#]')# AND PRODUCT_TREE.STOCK_ID=STOCKS.STOCK_ID AND STOCKS.IS_PRODUCTION=1",Datasource:"#dsn_type#",is_select:1);
                        if(GET_TREE.RECORDCOUNT)
                        {
                            for(ss=1;ss lte GET_TREE.RECORDCOUNT;ss=ss+1)
                            {
                                GET_COST=cfquery(SQLString:'SELECT PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM FROM GET_COST_ALL WHERE PRODUCT_ID = #evaluate('GET_TREE.PRODUCT_ID[#ss#]')# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'',dbtype='query',is_select:1);
                                if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+(GET_COST.PURCHASE_NET_SYSTEM * evaluate('GET_SPEC_ROW.AMOUNT[#ww#]') * evaluate('GET_TREE.AMOUNT[#ss#]'));
                                if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+(GET_COST.PURCHASE_EXTRA_COST_SYSTEM * evaluate('GET_SPEC_ROW.AMOUNT[#ww#]') * evaluate('GET_TREE.AMOUNT[#ss#]'));
                            }
                        }else
                        {
                            GET_COST=cfquery(SQLString:'SELECT PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM FROM GET_COST_ALL WHERE PRODUCT_ID = #evaluate('GET_SPEC_ROW.PRODUCT_ID[#ww#]')# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'',dbtype='query',is_select:1);
                            if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+(GET_COST.PURCHASE_NET_SYSTEM* evaluate('GET_SPEC_ROW.AMOUNT[#ww#]'));
                            if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+(GET_COST.PURCHASE_EXTRA_COST_SYSTEM*evaluate('GET_SPEC_ROW.AMOUNT[#ww#]'));
                        }
                    }
                }
                else
                {
                    GET_TREE_PROD=cfquery(SQLString:"SELECT PRODUCT_TREE.RELATED_ID STOCK_ID,PRODUCT_TREE.AMOUNT,STOCKS.PRODUCT_ID FROM PRODUCT_TREE,STOCKS WHERE PRODUCT_TREE.PRODUCT_ID IS NOT NULL AND PRODUCT_TREE.STOCK_ID = #arguments.stock_id# AND PRODUCT_TREE.RELATED_ID=STOCKS.STOCK_ID",Datasource:"#dsn_type#",is_select:1);
                    if(GET_TREE_PROD.RECORDCOUNT)
                    {
                        cost_info_product_list=listsort(valuelist(GET_TREE_PROD.PRODUCT_ID,','),'Numeric');
                        GET_COST_ALL=cfquery(SQLString:'SELECT PRODUCT_ID, PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM, START_DATE, RECORD_DATE FROM #dsn3_alias#.PRODUCT_COST PRODUCT_COST WHERE START_DATE <= #arguments.cost_date# AND PRODUCT_ID IN(#cost_info_product_list#)',Datasource:'#dsn_type#',is_select:1);
                        for(ww=1;ww lte GET_TREE_PROD.RECORDCOUNT;ww=ww+1)
                        {
                            GET_TREE=cfquery(SQLString:"SELECT PRODUCT_TREE.RELATED_ID,PRODUCT_TREE.AMOUNT,STOCKS.PRODUCT_ID FROM PRODUCT_TREE,STOCKS WHERE PRODUCT_TREE.PRODUCT_ID IS NOT NULL AND PRODUCT_TREE.STOCK_ID = #evaluate('GET_TREE_PROD.STOCK_ID[#ww#]')# AND PRODUCT_TREE.STOCK_ID=STOCKS.STOCK_ID",Datasource:"#dsn_type#",is_select:1);
                            if(GET_TREE.RECORDCOUNT)
                            {
                                for(ss=1;ss lte GET_TREE.RECORDCOUNT;ss=ss+1)
                                {
                                    GET_COST=cfquery(SQLString:'SELECT PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM FROM GET_COST_ALL WHERE PRODUCT_ID = #evaluate('GET_TREE.PRODUCT_ID[#ss#]')# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'#dsn_type#',dbtype:'query',is_select:1);
                                    if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+(GET_COST.PURCHASE_NET_SYSTEM * evaluate('GET_TREE_PROD.AMOUNT[#ww#]') * evaluate('GET_TREE.AMOUNT[#ss#]'));
                                    if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+(GET_COST.PURCHASE_EXTRA_COST_SYSTEM * evaluate('GET_TREE_PROD.AMOUNT[#ww#]') * evaluate('GET_TREE.AMOUNT[#ss#]'));
                                }
                            }else
                            {
                                GET_COST=cfquery(SQLString:'SELECT PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM FROM GET_COST_ALL WHERE PRODUCT_ID = #evaluate('GET_TREE_PROD.PRODUCT_ID[#ww#]')# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'#dsn_type#',dbtype:'query',is_select:1);
                                if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+(GET_COST.PURCHASE_NET_SYSTEM * evaluate('GET_TREE_PROD.AMOUNT[#ww#]'));
                                if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+(GET_COST.PURCHASE_EXTRA_COST_SYSTEM * evaluate('GET_TREE_PROD.AMOUNT[#ww#]'));
                            }
                        }
                    
                    }else
                    {
                        //GET_PROD=cfquery(SQLString:'SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS STOCKS WHERE STOCK_ID = #arguments.stock_id#',Datasource:'#dsn_type#',is_select:1);
                        if(GET_PROD.RECORDCOUNT)
                        {
                            GET_COST=cfquery(SQLString:'SELECT PRODUCT_ID, PRODUCT_COST, PRODUCT_COST_ID,MONEY, PURCHASE_NET_SYSTEM, PURCHASE_EXTRA_COST_SYSTEM, START_DATE, RECORD_DATE FROM #dsn3_alias#.PRODUCT_COST PRODUCT_COST WHERE START_DATE <= #arguments.cost_date# AND PRODUCT_ID = #GET_PROD.PRODUCT_ID# ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC',Datasource:'#dsn_type#',is_select:1);
                            if(len(GET_COST.RECORDCOUNT))maliyet_id=GET_COST.PRODUCT_COST_ID;
                            if(len(GET_COST.PURCHASE_NET_SYSTEM))toplam_maliyet_sistem=toplam_maliyet_sistem+GET_COST.PURCHASE_NET_SYSTEM;
                            if(len(GET_COST.PURCHASE_EXTRA_COST_SYSTEM))toplam_maliyet_extra_sistem=toplam_maliyet_extra_sistem+GET_COST.PURCHASE_EXTRA_COST_SYSTEM;
                        }
                    }
                }
            }else
            {//alis islemi ise standart alisi yollar maliyet olarak
                GET_PROD=cfquery(SQLString:'SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS STOCKS WHERE STOCK_ID = #arguments.stock_id#',Datasource:'#dsn_type#',is_select:1);
                if(GET_PROD.RECORDCOUNT)
                {
                    GET_COST=cfquery(SQLString:'SELECT PRICE, MONEY FROM #dsn3_alias#.PRICE_STANDART PRICE_STANDART WHERE PRICE_STANDART.PURCHASESALES = 0 AND PRICE_STANDART.PRICESTANDART_STATUS = 1 AND PRICE_STANDART.PRODUCT_ID = #GET_PROD.PRODUCT_ID#',Datasource:'#dsn_type#',is_select:1);
                    if(GET_COST.MONEY eq session.ep.money)
                    {
                        if(len(GET_COST.PRICE))toplam_maliyet_sistem=toplam_maliyet_sistem+GET_COST.PRICE;
                    }else
                    {
                        GET_MONEY=cfquery(SQLString:"SELECT (RATE2/RATE1) RATE FROM #dsn_alias#.SETUP_MONEY PRICE_STANDART WHERE PERIOD_ID=#session.ep.period_id# AND MONEY_STATUS = 1 AND MONEY='#GET_COST.MONEY#' AND COMPANY_ID=#session.ep.company_id#",Datasource:"#dsn_type#",is_select:1);
                        if(len(GET_COST.PRICE) and GET_MONEY.RECORDCOUNT) toplam_maliyet_sistem=GET_COST.PRICE*GET_MONEY.RATE;
                    }
                    toplam_maliyet_extra_sistem=0;
                }
            }
        }
        if(not len(maliyet_id)) maliyet_id=0;
        if(not len(toplam_maliyet_sistem)) toplam_maliyet_sistem=0;
        if(not len(toplam_maliyet_extra_sistem)) toplam_maliyet_extra_sistem=0;
        return '#maliyet_id#,#toplam_maliyet_sistem#,#toplam_maliyet_extra_sistem#';
        </cfscript>
    </cffunction>
    <!--- get_cost.cfm --->
    
	<!--- cost_action.cfm --->
	<cffunction name="cost_action" returntype="numeric" output="TRUE">
        <!---
        by : TolgaS 20061205
            TolgaS 20070601
        notes : 
            .....bir islemden(fatura, irasaliye,stok fis veya uretim) sonra o belge ile ilgili maliyet duzenlemelerinin yapilmasi.....
            fonsiyon bir popup açıyor ve o sayfada cfhttp ile yönlenme yapılıyor ve popup kapanıyor. popup olmasının sebebi sayfanın beklemesini engellemek bu sayade kullanıcı işlemine devam ederken arkada maliyet işlemi çalışmaya devam ediyor...
            PRODUCT_COST_LOG tablosuna kayit atilliyor fonsiyon basinda islem bittimindde objects2.emptypopup_cost_action daki belgede PRODUCT_COST_REFERENCE tablosuna kayit atiyor yani PRODUCT_COST_LOG da kayitli olan ancak PRODUCT_COST_REFERENCE olamyanlar yarim kalmis islemlerdir
        usage :
            cost_action(
                    action_type: 1, (1:fatura, 2:irsaliye, 3: fis, 4:uretim, 5: stok virman,6: masraf fişi)
                    action_id: invoce.invoice_id, (belge idsi)
                    query_type:1 (yapilan islem turu (1:ekleme,2:guncelleme,3:silme))
                );
        --->
        <cfargument name="action_type" type="numeric" required="yes" default="1"> <!--- fatura:1 , irsaliye:2, fis:3, üretim:4 , stok virman:5 --->
        <cfargument name="action_id" type="numeric" required="yes"><!--- islem tipi idsi --->
        <cfargument name="query_type" type="numeric" required="yes" default="1"><!--- islem silme güncelleme mi yoksa eklememi add:1 , update:2 , delete: 3 --->
        <cfargument name="dsn_type" type="string" required="no" default="#dsn3#">
        <cfargument name="period_dsn_type" type="string" required="no" default="#dsn2#">
        <!--- 	
            <cfargument name="user_id" type="numeric" required="no" default="#session.ep.userid#"><!--- islemi yapan 0 bunlar schedulle yollanmalı diger yerlerde gerek yok --->
            <cfargument name="period_id" type="numeric" required="no" default="#session.ep.period_id#"><!--- period bunlar schedulle yollanmalı diger yerlerde gerek yok--->
            <cfargument name="company_id" type="numeric" required="no" default="#session.ep.company_id#"><!--- sirket bunlar schedulle yollanmalı diger yerlerde gerek yok--->
         --->
     <cfargument name="is_popup" type="numeric" required="no" default="1"><!--- popup acılsınmı yoksa mevcut sayfadamı yonlensin 1: popup 0:mevcut sayfa  (satış işlemlerinde kullanılıyor bir sonraki alışı bularak tekrar çalıştığından bu yol izlendi)--->
        <cfargument name="multi_cost_page" type="string" required="no" default=""><!--- Gruplanmış üretim sonuçları için maliyet oluştururken her biri için maliyet oluştursun diye popup isimlerini değiştirmek için eklendi,maliyete bu kısım için bir blok eklenince kaldırılacak. --->
        <cfif isdefined('arguments.multi_cost_page') and arguments.multi_cost_page is 1>
            <cfset popup_page_name = "add_cost_wind_#arguments.action_id#">
        <cfelse>
            <cfset popup_page_name = "add_cost_wind">
        </cfif>
            <script type="text/javascript">
                <cfif isDefined("session.pda")>
                    window.open('<cfoutput>#request.self#?fuseaction=pda.emptypopup_cost_action&action_type=#arguments.action_type#&action_id=#arguments.action_id#&dsn_type=#arguments.dsn_type#&period_dsn_type=#arguments.period_dsn_type#&query_type=#arguments.query_type#&user_id=#session.pda.userid#&period_id=#session.pda.period_id#&company_id=#session.pda.our_company_id#</cfoutput>',"#popup_page_name#","height=75,width=350");
                <cfelse>
                    window.open('<cfoutput>#request.self#?fuseaction=objects.emptypopup_cost_action&action_type=#arguments.action_type#&action_id=#arguments.action_id#&dsn_type=#arguments.dsn_type#&period_dsn_type=#arguments.period_dsn_type#&query_type=#arguments.query_type#&user_id=#session.ep.userid#&period_id=#session.ep.period_id#&company_id=#session.ep.company_id#</cfoutput>',"#popup_page_name#","height=75,width=350");
                </cfif>
            </script>
            <!---<cflocation url="#request.self#?fuseaction=objects.emptypopup_cost_action&action_type=#arguments.action_type#&action_id=#arguments.action_id#&dsn_type=#arguments.dsn_type#&period_dsn_type=#arguments.period_dsn_type#&query_type=#arguments.query_type#&user_id=#arguments.user_id#&period_id=#arguments.period_id#&company_id=#arguments.company_id#" addtoken="no">--->
        <cfquery name="ADD_PROCESS_START" datasource="#dsn1#">
            INSERT INTO 
                PRODUCT_COST_LOG
                (
                    ACTION_TYPE,
                    ACTION_ID,
                    QUERY_TYPE,
                    PERIOD_ID,
                    OUR_COMPANY_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
            VALUES
                (
                    #arguments.action_type#,
                    #arguments.action_id#,
                    #arguments.query_type#,
                    <cfif isDefined("session.pda")>
                        #session.pda.period_id#,
                        #session.pda.our_company_id#,
                        #now()#,
                        #session.pda.userid#,
                    <cfelse>
                        #session.ep.period_id#,
                        #session.ep.company_id#,
                        #now()#,
                        #session.ep.userid#,
                    </cfif>
                    '#cgi.REMOTE_ADDR#'
                )
        </cfquery>
        <cfreturn 1>
    </cffunction>
	<!--- cost_action.cfm --->

	<!--- get_user_accounts.cfm --->
	<!---
        by : 
        notes : İstenen üyenin,calisanin veya urunun muhasebe hesabini döndüren fonksiyonlar...
                -Bu fonksiyonlarin hepsi tek parametre ile, param ismi belirtilmeden int degerlerle kullanılır
                -Dikkat edilirse genel olarak hep donem db den çalistigimiz gorulur ve transaction sorunu olmaması için
                 donem db icinden maindb lere eriserek calisir.
        usage :
            GET_CONSUMER_PERIOD(i);
            GET_COMPANY_PERIOD(123);
            GET_EMPLOYEE_PERIOD('#some_query.some_id#');
            get_product_account(prod_id:1,period_id:1); //period_id optional verilmezse session dakini alir.
            //table_type_id: EGer Müsterinin Dovizli hesabi isteniyorsa table_type_id=1 olarak fonksiyon cagirilmalidir
        revisions : 20040304
    --->
    <cffunction name="GET_CONSUMER_PERIOD" output="false">
        <cfargument name="consumer_id" type="numeric" required="true">
        <cfargument name="period_id" type="numeric">
        <cfargument name="basket_money_db" type="string" default="#dsn2#">
        <cfargument name="acc_type_id" type="string" default="">
        <cfquery name="GET_CONSUMER_ACCOUNT_CODE" datasource="#arguments.basket_money_db#">
            SELECT
                 <cfif len(arguments.acc_type_id)>
                    <cfif arguments.acc_type_id eq -1>
						ACCOUNT_CODE
                    <cfelseif arguments.acc_type_id eq -6>
						RECEIVED_GUARANTEE_ACCOUNT
                    <cfelseif arguments.acc_type_id eq -7>
						GIVEN_GUARANTEE_ACCOUNT
                    <cfelseif arguments.acc_type_id eq -4>
						RECEIVED_ADVANCE_ACCOUNT
                    <cfelseif arguments.acc_type_id eq -5>
						ADVANCE_PAYMENT_CODE
                    <cfelseif arguments.acc_type_id eq -8>
						KONSINYE_CODE
                    <cfelseif arguments.acc_type_id eq -2>
						SALES_ACCOUNT
                    <cfelseif arguments.acc_type_id eq -3>
						PURCHASE_ACCOUNT
					<cfelseif arguments.acc_type_id eq 0>		
						ACCOUNT_CODE
                    <cfelseif arguments.acc_type_id eq -9>		
						EXPORT_REGISTERED_SALES_ACCOUNT
                    <cfelseif arguments.acc_type_id eq -10>		
						EXPORT_REGISTERED_BUY_ACCOUNT
                    <cfelse>
						ACCOUNT_CODE
                    </cfif>
                    as ACCOUNT_CODE
               <cfelse>
                    ACCOUNT_CODE
               </cfif>
            FROM
                #dsn_alias#.CONSUMER_PERIOD
            WHERE
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                <cfif not isDefined('arguments.period_id')>
                    <cfif isDefined('session.ep')>
                        AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    <cfelseif isDefined('session.pp')>
                        AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
                    <cfelseif isDefined('session.ww')>
                        AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
                    </cfif>
                <cfelse>
                    AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_CONSUMER_ACCOUNT_CODE.ACCOUNT_CODE>
    </cffunction>
    <cffunction name="GET_COMPANY_PERIOD" output="false">
        <cfargument name="company_id" type="numeric" required="true">
        <cfargument name="period_id" type="numeric">
        <cfargument name="basket_money_db" type="string" default="#dsn2#">
        <cfargument name="acc_type_id" type="string" default="">
        <cfquery name="GET_COMPANY_ACCOUNT_CODE" datasource="#arguments.basket_money_db#">
            SELECT
                <cfif len(arguments.acc_type_id)>
                    <cfif arguments.acc_type_id eq -1>
						ACCOUNT_CODE
                    <cfelseif arguments.acc_type_id eq -6>
						RECEIVED_GUARANTEE_ACCOUNT
                    <cfelseif arguments.acc_type_id eq -7>
						GIVEN_GUARANTEE_ACCOUNT
                    <cfelseif arguments.acc_type_id eq -4>
						RECEIVED_ADVANCE_ACCOUNT
                    <cfelseif arguments.acc_type_id eq -5>
						ADVANCE_PAYMENT_CODE
                    <cfelseif arguments.acc_type_id eq -8>
						KONSINYE_CODE
                    <cfelseif arguments.acc_type_id eq -2>
						SALES_ACCOUNT
                    <cfelseif arguments.acc_type_id eq -3>
						PURCHASE_ACCOUNT
					<cfelseif arguments.acc_type_id eq 0>		
						ACCOUNT_CODE
                    <cfelseif arguments.acc_type_id eq -9>		
						EXPORT_REGISTERED_SALES_ACCOUNT
                    <cfelseif arguments.acc_type_id eq -10>		
						EXPORT_REGISTERED_BUY_ACCOUNT
                    <cfelse>
						ACCOUNT_CODE
                    </cfif>
               as ACCOUNT_CODE
               <cfelse>
                ACCOUNT_CODE
               </cfif>
            FROM
                #dsn_alias#.COMPANY_PERIOD
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                <cfif not isDefined('arguments.period_id') or (isdefined("arguments.period_id") and not len(arguments.period_id))>
                    <cfif isDefined('session.ep')>
                        AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    <cfelseif isDefined('session.pp')>
                        AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
                    <cfelseif isDefined('session.ww')>
                        AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
                    </cfif>
                <cfelse>
                    AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_COMPANY_ACCOUNT_CODE.ACCOUNT_CODE>
    </cffunction>
    <cffunction name="GET_EMPLOYEE_PERIOD" output="false">
        <cfargument name="employee_id" type="numeric" required="true">
        <cfargument name="acc_type_id" type="string" default="0">
        <cfargument name="basket_money_db" type="string" default="#dsn2#">
        <cfargument name="basket_money_db_dsn3" type="string" default="#dsn3#">
        <cfargument name="period_id" type="numeric">
        <cfquery name="EMP_ACCOUNT_CODE" datasource="#arguments.basket_money_db#">
            SELECT TOP 1
                EIOP.ACCOUNT_CODE
            FROM
                #dsn_alias#.EMPLOYEES_IN_OUT EIO,
                <cfif len(arguments.acc_type_id) and arguments.acc_type_id neq 0>
                    #dsn_alias#.EMPLOYEES_ACCOUNTS EIOP
                <cfelse>
                    #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD EIOP
                </cfif>
            WHERE
                EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                 <cfif len(arguments.acc_type_id) and arguments.acc_type_id neq 0>
                    AND EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID
                <cfelse>
                    AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID
                </cfif>
                <cfif len(arguments.acc_type_id) and arguments.acc_type_id neq 0>
                    AND EIOP.ACC_TYPE_ID = #arguments.acc_type_id#
                </cfif>
                <cfif not isDefined('arguments.period_id')>
                    <cfif isDefined('session.ep')>
                        AND	EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    <cfelseif isDefined('session.pp')>
                        AND	EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
                    <cfelseif isDefined('session.ww')>
                        AND	EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
                    </cfif>
                <cfelse>
                    AND	EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
                </cfif>
            ORDER BY
                EIO.IN_OUT_ID DESC
        </cfquery>
        <cfif (emp_account_code.recordcount eq 0 or not len(emp_account_code.account_code))>
            <cfquery name="EMP_ACCOUNT_CODE" datasource="#arguments.basket_money_db#">
                SELECT PERSONAL_ADVANCE_ACCOUNT AS ACCOUNT_CODE FROM #basket_money_db_dsn3#.SETUP_SALARY_PAYROLL_ACCOUNTS
            </cfquery>
        </cfif>
        <cfreturn EMP_ACCOUNT_CODE.ACCOUNT_CODE>
    </cffunction>
    <cffunction name="get_product_account" returntype="struct" output="false">
        <!--- structure olarak ürün muhasebe kodlarini döndürür --->
        <cfargument name="prod_id" required="true" type="numeric">
        <cfargument name="period_id" type="numeric">
        <cfargument name="product_account_db" type="string" default="#DSN2#">
        <cfargument name="product_alias_db" type="string" default="#dsn3_alias#">	
        <cfargument name="department_id" type="string" default="">	
        <cfargument name="location_id" type="string" default="">
        <!--- depo bazında muhasebeleştirme yapılıyorsa depodan alıyor muhasebe kodlarını --->
        <cfif len(arguments.department_id) and len(arguments.location_id) and arguments.department_id neq 0 and arguments.location_id neq 0>
            <cfquery datasource="#arguments.product_account_db#" name="get_pro_account_codes">
                SELECT 
                    ACCOUNT_CODE,ACCOUNT_CODE_PUR,ACCOUNT_DISCOUNT,ACCOUNT_PRICE,ACCOUNT_PRICE_PUR,ACCOUNT_YURTDISI_PUR,
                    MATERIAL_CODE,ACCOUNT_PUR_IADE,ACCOUNT_IADE,ACCOUNT_YURTDISI,ACCOUNT_DISCOUNT_PUR,SALE_PRODUCT_COST,
                    PRODUCTION_COST,ACCOUNT_EXPENDITURE,ACCOUNT_LOSS,'' RECEIVED_PROGRESS_CODE,'' PROVIDED_PROGRESS_CODE,SCRAP_CODE,
                    '' SALE_MANUFACTURED_COST,'' KONSINYE_SALE_CODE,SCRAP_CODE_SALE,MATERIAL_CODE_SALE,PRODUCTION_COST_SALE,
                    '' KONSINYE_PUR_CODE,'' PROMOTION_CODE,
                    '' OVER_COUNT, '' EXE_VAT_SALE_INVOICE,
                    1 ACCRUAL_MONTH,
                    1 ACCRUAL_MONTH_IFRS,
                    '' ACCRUAL_INCOME_ITEM_ID,
                    '' ACCRUAL_EXPENSE_ITEM_ID,
                    '' NEXT_MONTH_INCOMES_ACC_CODE,
                    '' NEXT_YEAR_INCOMES_ACC_CODE,
                    '' NEXT_MONTH_EXPENSES_ACC_CODE,
                    '' NEXT_YEAR_EXPENSES_ACC_CODE,
                    0 RUN_REQUIREMENT,
                    '' COST_EXPENSE_CENTER_ID,
                    '' EXPENSE_CENTER_ID,
                    0 AS FIRST_12_TO_MONTH,
                    0 AS START_FROM_DELIVERY_DATE,
                    0 AS DISTRIBUTE_TO_FISCAL_END,
                    0 AS DISTRIBUTE_DAY_BASED,
                    0 AS PAST_MONTHS_TO_FIRST,
                    0 AS FIRST_12_TO_MONTH_IFRS,
                    0 AS START_FROM_DELIVERY_DATE_IFRS,
                    0 AS DISTRIBUTE_TO_FISCAL_END_IFRS,
                    0 AS DISTRIBUTE_DAY_BASED_IFRS,
                    0 AS PAST_MONTHS_TO_FIRST_IFRS,
                    '' AS NEXT_MONTH_INCOMES_ACC_KEY,
                    '' AS NEXT_YEAR_INCOMES_ACC_KEY,
                    '' AS NEXT_MONTH_EXPENSES_ACC_KEY,
                    '' AS NEXT_YEAR_EXPENSES_ACC_KEY,
                    '' AS ACCRUAL_MONTH_BUDGET,
                    '' AS ACCOUNT_EXPORTREGISTERED,
                    '' AS INCOMING_STOCK,
                    '' AS OUTGOING_STOCK

                FROM 
                    #dsn_alias#.STOCKS_LOCATION_PERIOD
                WHERE
                    DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                    AND	LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#">
                <cfif not (isDefined('arguments.period_id') and len(arguments.period_id))>
                    <cfif isDefined('session.ep')>
                        AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    <cfelseif isDefined('session.pp')>
                        AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
                    <cfelseif isDefined('session.ww')>
                        AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
                    </cfif>
                <cfelse>
                    AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
                </cfif>
            </cfquery>
        <cfelse>
            <cfquery datasource="#arguments.product_account_db#" name="get_pro_account_codes">
                SELECT 
                    ACCOUNT_CODE,ACCOUNT_CODE_PUR,ACCOUNT_DISCOUNT,ACCOUNT_PRICE,ACCOUNT_PRICE_PUR,ACCOUNT_YURTDISI_PUR,ACCOUNT_EXPORTREGISTERED,OUTGOING_STOCK,INCOMING_STOCK,
                    MATERIAL_CODE,ACCOUNT_PUR_IADE,ACCOUNT_IADE,ACCOUNT_YURTDISI,ACCOUNT_DISCOUNT_PUR,SALE_PRODUCT_COST,
                    PRODUCTION_COST,ACCOUNT_EXPENDITURE,ACCOUNT_LOSS,RECEIVED_PROGRESS_CODE,PROVIDED_PROGRESS_CODE,SCRAP_CODE,
                    SALE_MANUFACTURED_COST,KONSINYE_SALE_CODE,SCRAP_CODE_SALE,MATERIAL_CODE_SALE,PRODUCTION_COST_SALE,
                    KONSINYE_PUR_CODE,PROMOTION_CODE,
                    OVER_COUNT,EXE_VAT_SALE_INVOICE,
                    ACCRUAL_MONTH,
                    ACCRUAL_MONTH_IFRS,
                    ACCRUAL_INCOME_ITEM_ID,
                    ACCRUAL_EXPENSE_ITEM_ID,
                    NEXT_MONTH_INCOMES_ACC_CODE,
                    NEXT_YEAR_INCOMES_ACC_CODE,
                    NEXT_MONTH_EXPENSES_ACC_CODE,
                    NEXT_YEAR_EXPENSES_ACC_CODE,
                    RUN_REQUIREMENT,
                    COST_EXPENSE_CENTER_ID,
                    EXPENSE_CENTER_ID,
                    FIRST_12_TO_MONTH,
                    START_FROM_DELIVERY_DATE,
                    DISTRIBUTE_TO_FISCAL_END,
                    DISTRIBUTE_DAY_BASED,
                    PAST_MONTHS_TO_FIRST,
                    FIRST_12_TO_MONTH_IFRS,
                    START_FROM_DELIVERY_DATE_IFRS,
                    DISTRIBUTE_TO_FISCAL_END_IFRS,
                    DISTRIBUTE_DAY_BASED_IFRS,
                    PAST_MONTHS_TO_FIRST_IFRS,
                    NEXT_MONTH_INCOMES_ACC_KEY,
                    NEXT_YEAR_INCOMES_ACC_KEY,
                    NEXT_MONTH_EXPENSES_ACC_KEY,
                    NEXT_YEAR_EXPENSES_ACC_KEY,
                    ACCRUAL_MONTH_BUDGET
                FROM 
                    #arguments.product_alias_db#.PRODUCT_PERIOD
                WHERE
                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_id#">
                <cfif not (isDefined('arguments.period_id') and len(arguments.period_id))>
                    <cfif isDefined('session.ep')>
                        AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    <cfelseif isDefined('session.pp')>
                        AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
                    <cfelseif isDefined('session.ww')>
                        AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
                    </cfif>
                <cfelse>
                    AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
                </cfif>
            </cfquery>
        </cfif>
        <cfscript>
            product_account_codes = StructNew();
            product_account_codes = StructNew();
            product_account_codes.ACCOUNT_CODE = get_pro_account_codes.ACCOUNT_CODE;
            product_account_codes.ACCOUNT_CODE_PUR = get_pro_account_codes.ACCOUNT_CODE_PUR;
            product_account_codes.ACCOUNT_DISCOUNT = get_pro_account_codes.ACCOUNT_DISCOUNT;
            product_account_codes.ACCOUNT_PRICE = get_pro_account_codes.ACCOUNT_PRICE;
            product_account_codes.ACCOUNT_PRICE_PUR = get_pro_account_codes.ACCOUNT_PRICE_PUR;
            product_account_codes.ACCOUNT_PUR_IADE = get_pro_account_codes.ACCOUNT_PUR_IADE;
            product_account_codes.ACCOUNT_IADE = get_pro_account_codes.ACCOUNT_IADE;
            product_account_codes.ACCOUNT_YURTDISI = get_pro_account_codes.ACCOUNT_YURTDISI;
            product_account_codes.ACCOUNT_YURTDISI_PUR = get_pro_account_codes.ACCOUNT_YURTDISI_PUR;
            product_account_codes.ACCOUNT_EXPORTREGISTERED = get_pro_account_codes.ACCOUNT_EXPORTREGISTERED;
            product_account_codes.OUTGOING_STOCK= get_pro_account_codes.OUTGOING_STOCK;
            product_account_codes.INCOMING_STOCK= get_pro_account_codes.INCOMING_STOCK;
            product_account_codes.ACCOUNT_DISCOUNT_PUR = get_pro_account_codes.ACCOUNT_DISCOUNT_PUR;
            product_account_codes.PRODUCTION_COST = get_pro_account_codes.PRODUCTION_COST;
            product_account_codes.MATERIAL_CODE = get_pro_account_codes.MATERIAL_CODE;
            product_account_codes.ACCOUNT_EXPENDITURE = get_pro_account_codes.ACCOUNT_EXPENDITURE;
            product_account_codes.ACCOUNT_LOSS = get_pro_account_codes.ACCOUNT_LOSS;
            product_account_codes.SALE_PRODUCT_COST = get_pro_account_codes.SALE_PRODUCT_COST;
            product_account_codes.RECEIVED_PROGRESS_CODE = get_pro_account_codes.RECEIVED_PROGRESS_CODE;
            product_account_codes.PROVIDED_PROGRESS_CODE = get_pro_account_codes.PROVIDED_PROGRESS_CODE;
            product_account_codes.SCRAP_CODE = get_pro_account_codes.SCRAP_CODE;
            product_account_codes.SALE_MANUFACTURED_COST = get_pro_account_codes.SALE_MANUFACTURED_COST;
            product_account_codes.KONSINYE_SALE_CODE = get_pro_account_codes.KONSINYE_SALE_CODE;
            product_account_codes.SCRAP_CODE_SALE = get_pro_account_codes.SCRAP_CODE_SALE;
            product_account_codes.PRODUCTION_COST_SALE = get_pro_account_codes.PRODUCTION_COST_SALE;
            product_account_codes.MATERIAL_CODE_SALE = get_pro_account_codes.MATERIAL_CODE_SALE;
            product_account_codes.KONSINYE_PUR_CODE = get_pro_account_codes.KONSINYE_PUR_CODE;
            product_account_codes.PROMOTION_CODE = get_pro_account_codes.PROMOTION_CODE;
            product_account_codes.OVER_COUNT = get_pro_account_codes.OVER_COUNT;
            product_account_codes.EXE_VAT_SALE_INVOICE = get_pro_account_codes.EXE_VAT_SALE_INVOICE;
            product_account_codes.ACCRUAL_MONTH = get_pro_account_codes.ACCRUAL_MONTH;
            product_account_codes.ACCRUAL_MONTH_IFRS = get_pro_account_codes.ACCRUAL_MONTH_IFRS;
            product_account_codes.ACCRUAL_INCOME_ITEM_ID = get_pro_account_codes.ACCRUAL_INCOME_ITEM_ID;
            product_account_codes.ACCRUAL_EXPENSE_ITEM_ID = get_pro_account_codes.ACCRUAL_EXPENSE_ITEM_ID;
            product_account_codes.NEXT_MONTH_INCOMES_ACC_CODE = get_pro_account_codes.NEXT_MONTH_INCOMES_ACC_CODE;
            product_account_codes.NEXT_YEAR_INCOMES_ACC_CODE = get_pro_account_codes.NEXT_YEAR_INCOMES_ACC_CODE;
            product_account_codes.NEXT_MONTH_EXPENSES_ACC_CODE = get_pro_account_codes.NEXT_MONTH_EXPENSES_ACC_CODE;
            product_account_codes.NEXT_YEAR_EXPENSES_ACC_CODE = get_pro_account_codes.NEXT_YEAR_EXPENSES_ACC_CODE;
            product_account_codes.RUN_REQUIREMENT = get_pro_account_codes.RUN_REQUIREMENT;
            product_account_codes.COST_EXPENSE_CENTER_ID = get_pro_account_codes.COST_EXPENSE_CENTER_ID;
            product_account_codes.EXPENSE_CENTER_ID = get_pro_account_codes.EXPENSE_CENTER_ID;
            product_account_codes.FIRST_12_TO_MONTH = get_pro_account_codes.FIRST_12_TO_MONTH;
            product_account_codes.START_FROM_DELIVERY_DATE = get_pro_account_codes.START_FROM_DELIVERY_DATE;
            product_account_codes.DISTRIBUTE_TO_FISCAL_END = get_pro_account_codes.DISTRIBUTE_TO_FISCAL_END;
            product_account_codes.DISTRIBUTE_DAY_BASED = get_pro_account_codes.DISTRIBUTE_DAY_BASED;
            product_account_codes.PAST_MONTHS_TO_FIRST = get_pro_account_codes.PAST_MONTHS_TO_FIRST;
            product_account_codes.FIRST_12_TO_MONTH_IFRS = get_pro_account_codes.FIRST_12_TO_MONTH_IFRS;
            product_account_codes.START_FROM_DELIVERY_DATE_IFRS = get_pro_account_codes.START_FROM_DELIVERY_DATE_IFRS;
            product_account_codes.DISTRIBUTE_TO_FISCAL_END_IFRS = get_pro_account_codes.DISTRIBUTE_TO_FISCAL_END_IFRS;
            product_account_codes.DISTRIBUTE_DAY_BASED_IFRS = get_pro_account_codes.DISTRIBUTE_DAY_BASED_IFRS;
            product_account_codes.PAST_MONTHS_TO_FIRST_IFRS = get_pro_account_codes.PAST_MONTHS_TO_FIRST_IFRS;
            product_account_codes.NEXT_MONTH_INCOMES_ACC_KEY = get_pro_account_codes.NEXT_MONTH_INCOMES_ACC_KEY;
            product_account_codes.NEXT_YEAR_INCOMES_ACC_KEY = get_pro_account_codes.NEXT_YEAR_INCOMES_ACC_KEY;
            product_account_codes.NEXT_MONTH_EXPENSES_ACC_KEY = get_pro_account_codes.NEXT_MONTH_EXPENSES_ACC_KEY;
            product_account_codes.NEXT_YEAR_EXPENSES_ACC_KEY = get_pro_account_codes.NEXT_YEAR_EXPENSES_ACC_KEY;
            product_account_codes.ACCRUAL_MONTH_BUDGET = get_pro_account_codes.ACCRUAL_MONTH_BUDGET;
        </cfscript>
        <cfreturn product_account_codes>
    </cffunction>
    
    <cffunction name="getLang" returntype="any" output="false">
        <cfargument name="module" default="">
        <cfargument name="item" default="">
        <cfargument name="dictionary_id" default="">
        <cfif len(arguments.dictionary_id) and isNumeric(arguments.dictionary_id)>
            <cftry>
                <cfset sira = listFindNoCase(application.langsAllList,session.ep.language,',')>
                <cfscript>
                    data = listGetAt(application.langArrayAll['#trim(ListFirst(arguments.dictionary_id,'.'))#'],sira,'█');
                    if(isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1){
                        d_id = trim(ListFirst(arguments.dictionary_id,'.'));
                        arrayappend(request.pagelangList,{id:d_id,deger:replace(data,"'","","all"),type:'dictionary',module:''});
                    }
                    if(isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1)
                        s = chr(124);
                    else
                        s = '';
                    data = s&data&s;
                </cfscript>
                <cfcatch type="any">
                    <cfset data = "?">
                </cfcatch>
            </cftry>
        <cfelseif len(arguments.item)>
            <cftry>
                <cfscript>
                    data = listGetAt(application.langArray['#arguments.module#']['#trim(ListFirst(arguments.item,'.'))#'],listFindNoCase(application.langsAllList,session.ep.language,','),'█');
                    if(isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1){
                        arrayappend(request.pagelangList,{id:trim(ListFirst(arguments.item,'.')),deger:replace(data,"'","","all"),type:'module',module:arguments.module});
                    }
                    if(isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1)
                        s = chr(124);
                    else
                        s = '';
                    data= s&data&s;
                </cfscript>
                <cfcatch type="any">
                    <cfset data = "?">
                </cfcatch>
            </cftry>
        <cfelse>
            <cftry>
                <cfset data = listGetAt(application.langArrayAll[arguments.module],listFindNoCase(application.langsAllList,session.ep.language,','),'█')>
                <cfcatch type="any">
                    <cfset data = "?">
                </cfcatch>
            </cftry>
        </cfif>
        <cfreturn data>
    </cffunction>
    
    <!---
    <cffunction name="getLang" returntype="any" output="false">
    	<cfif arguments[2]>
			<cfset data = listGetAt(application.langArray['#arguments[1]#']['#trim(ListFirst(arguments[2],'.'))#'],listFindNoCase(application.langsAllList,session.ep.language,','),'█')>
        <cfelse>
        	<cfset data = listGetAt(application.langArrayAll['#arguments[1]#'],listFindNoCase(application.langsAllList,session.ep.language,','),'█')>
        </cfif>
		<cfreturn data>
    </cffunction>
	--->
    
	<!--- get_user_accounts.cfm --->

	<!--- Struct array'e dönüştürülüyor. --->
<!---    <cffunction name="wrkUrlStrings" returntype="string" output="false">
    	<cfargument name="s" required="yes" type="array">
        <cfscript>
			/*  
				Sayfalama yaparken kullandığımız url_string ifadelerini attributes Struct'ını döndürerek kendisi oluşturur.ilk parametre her zaman url ifadelerini tutan değişkenimizin ismi olmalıdır,
				diğer parametreler ise sayfa içinde kullanılan değişken isimlerini ifade eder ve n tane olabilir.
				Örnek : wrkUrlStrings('url_str','is_submitted','keyword','station_id','location_id'); şeklinde kullanılır,bu durumda sayfanın içindeki tüm attributes değişkenlerinden uzunlukları olanlar "url_str" ismiyle set edilirler.
				M.ER 20 03 20009
			*/
			var arg_count = ArrayLen(s);
			'#Arguments[1]#' = "";
			for(url_str_indx = 2;url_str_indx lte arg_count; url_str_indx=url_str_indx+1){
				if(isdefined("attributes.#Arguments[url_str_indx]#"))// and len(Evaluate("attributes.#Arguments[url_str_indx]#"))
					if(isdate(Evaluate("attributes.#Arguments[url_str_indx]#")) and ListLen(Evaluate("attributes.#Arguments[url_str_indx]#"),",") eq 1)//1,2,3 gibi bir değer geldiğinde onuda tarih gibi algılıyordu dolayısı ile listlen kontrolü eklendi...
						'#Arguments[1]#' = '#Evaluate("#Arguments[1]#")#&#Arguments[url_str_indx]#=#URLEncodedFormat(DateFormat(Evaluate("attributes.#Arguments[url_str_indx]#"),'DD/MM/YYYY'))#';
					else
						'#Arguments[1]#' = '#Evaluate("#Arguments[1]#")#&#Arguments[url_str_indx]#=#URLEncodedFormat(Evaluate("attributes.#Arguments[url_str_indx]#"))#';
			/*if(isdefined("attributes.#Arguments[url_str_indx]#"))			
				writeoutput('#Arguments[url_str_indx]#---#URLEncodedFormat(Evaluate("attributes.#Arguments[url_str_indx]#"))#---#isdate(Evaluate("attributes.#Arguments[url_str_indx]#"))#__#ListLen(Evaluate("attributes.#Arguments[url_str_indx]#"),",")# <br/>');	*/
			}
		</cfscript>
        <cfreturn '#Arguments[1]#'>
    </cffunction>
	--->

<cffunction name="serializeJQXFormat" access="public" returntype="string">
    <cfargument name="queryName" required="true"><!--- Query name --->
    <cfset dataset = [] />
    
    <cfloop query="#arguments.queryName#">
        <cfset record = {} />
        <cfloop list="#arguments.queryName.columnList#" index="columns">
            <cfset record[columns] = arguments.queryName[#columns#][currentrow]>
        </cfloop>
        <cfset ArrayAppend(dataset, record) />
    </cfloop>
    <cfreturn replace(SerializeJSON(dataset),'//','')/>
</cffunction>
<cffunction name="licence" access="remote" returntype="string" returnFormat="plain">
    <cfargument name="status" required="yes" default="">
    <cfargument name="userId" required="yes" default="">
    <cfquery name="INSERTLIST" datasource="#dsn#">
		INSERT INTO USER_LICENCE (USER_ID,USER_ANSWER) VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#">,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">)
        <cfif arguments.status eq 0>
        	DELETE FROM WRK_SESSION WHERE USER_TYPE = 0 AND USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#">
        </cfif>
    </cfquery>
    <cfreturn arguments.status>
</cffunction>

<cffunction name="GET_USER_LICENCE" returntype="query">
    <cfquery name="GET_LICENCE_INFO" datasource="#dsn#">
        SELECT
            TEMPLATE_HEAD
        FROM
            TEMPLATE_FORMS
        WHERE
            IS_LICENCE = 1
    </cfquery>
    <cfreturn GET_LICENCE_INFO/>
</cffunction>

<cffunction name="GET_USER_LICENCE_RESULT" returntype="query">
	<cfargument name="userId" required="yes" default="">
    <cfquery name="GET_USER_LICENCE_RESULT" datasource="#dsn#">
        SELECT
            USER_ID
        FROM
            USER_LICENCE
        WHERE
            USER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#">
    </cfquery>
    <cfreturn GET_USER_LICENCE_RESULT>
</cffunction>

<!--- Tırnak sorununu düzeltir. --->
<cffunction name="wrk_eval" returntype="string" output="false">
	<!--- loop inen donen satirlarda evaluatten kaynaklanan tirnak isareti sorununu cozer --->
	<cfargument name="gelen" required="no" type="string">
	<cfset wrk_sql_value = "#replaceNoCase(trim(evaluate("#gelen#")),"'","''","ALL")#">
	<cfreturn wrk_sql_value>
</cffunction>

<cffunction name="attributeToStruct">
    <cfargument name="attr" type="struct">
    <cfargument name="prefix" type="string">
    <cfloop collection="#arguments.attr#" item="key">
        <cfif findNoCase(arguments.prefix, key)>
            <cfset "arguments.attr.#key#" = arguments.attr[key]>
            <cfset structDelete(arguments.attr, key)>
        </cfif>
    </cfloop>
</cffunction>
<!--- iki liste arasındaki farklı değerleri bulur Esma R. Uysal--->
<cffunction name="listCompare" output="false" returnType="string">
        <cfargument name="list1" type="string" required="true" />
        <cfargument name="list2" type="string" required="true" />
        
        <cfset var list1Array = ListToArray(arguments.List1) />
        <cfset var list2Array = ListToArray(arguments.List2) />
        
        <cfset list1Array.removeAll(list2Array) />
        
        <!— Return in list format —>
        <cfreturn ArrayToList(list1Array) />
    </cffunction>
</cfcomponent>