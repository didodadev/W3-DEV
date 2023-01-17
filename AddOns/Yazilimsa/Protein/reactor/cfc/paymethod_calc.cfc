<cfcomponent>
    <cfparam name="dsn" default="#application.SystemParam.SystemParam().dsn#">
    <cfset dsn_alias = "#dsn#">
    <cfparam name="dateformat_style" default="#session.ep.dateformat_style#">

	<cffunction name="calc_duedate" access="remote">
        <!---
            by : TolgaS 20191207
            notes : gelen parametrelere göre vade tarihi hesaplanır
            usage : 
            action_date : vadenin hesaplanmasında baz alınacak tarihi(fatura, belge tarihi) zorunlu
            paymethod_id: ödeme yöntemi idsi zorunlu
            due_day: gönderilen action_date üzerine eklenecek vade gün sayısı
            due_date: vade tarihi olarka tarih yollanabilir
            transaction_dsn: transaction içinde ise yollanmalı
            isAjax: ajax ile çağırıldığı zaman

            Fonksiyon geriye : 
                result.due_date : vade tarihi
                result.daydiff : vade tarihi
                result.isholiday : tatil günü için düzenleme yapıldı ise true
                result.next_day : haftanın belirli günü için düzenleme yapıldı ise true
            döner
        --->
        <cfargument name="action_date" required="true">
        <cfargument name="paymethod_id" required="true">
        <cfargument name="due_day">
        <cfargument name="due_date">
        <cfargument name="transaction_dsn">
        <cfargument name="isAjax">

        <cfif not isdefined("arguments.transaction_dsn") or not len(arguments.transaction_dsn)>
            <cfset transaction_dsn = dsn>
        </cfif>
        <cfif not len(arguments.action_date)>
            <cfset arguments.action_date = dateFormat(now(),dateformat_style)>
        </cfif>
        <cfset workcube_mode = application.SystemParam.SystemParam().workcube_mode>
        <cf_date tarih="arguments.action_date">
        <cfquery name="get_paymethod" datasource="#arguments.transaction_dsn#">
            SELECT 
                PAYMETHOD_ID
                ,IN_ADVANCE
                ,DUE_DATE_RATE
                ,DUE_DAY
                ,DUE_MONTH
                ,COMPOUND_RATE
                ,FINANCIAL_COMPOUND_RATE
                ,BALANCED_PAYMENT
                ,NO_COMPOUND_RATE
                ,PAYMENT_VEHICLE
                ,MONEY
                ,FIRST_INTEREST_RATE
                ,DELAY_INTEREST_DAY
                ,DELAY_INTEREST_RATE
                ,DUE_START_DAY
                ,PAYMETHOD_STATUS
                ,DUE_START_MONTH
				,ISNULL(IS_DUE_BEGINOFMONTH,0) AS IS_DUE_BEGINOFMONTH
                ,IS_DUE_ENDOFMONTH
                ,PAYMENT_MEANS_CODE
                ,PAYMENT_MEANS_CODE_NAME
                ,IS_DATE_CONTROL
                ,NEXT_DAY
                ,ISNULL(IS_BUSINESS_DUE_DAY,0) AS IS_BUSINESS_DUE_DAY
           FROM
                #dsn_alias#.SETUP_PAYMETHOD
            WHERE
                PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paymethod_id#">
        </cfquery>
        
        <cfscript>
        result.isholiday = 0;
        result.next_day = 0;

        due_date_ = arguments.action_date;
        if(isdefined("arguments.due_day") and len(arguments.due_day)){
            due_date_ =DateAdd("d",arguments.due_day,due_date_);
        }else if(isdefined("arguments.due_date") and len(arguments.due_date)){
            due_date_ = dateformat(arguments.due_date,dateformat_style);
        }else {
            
             //vadeye belirlenen ay ekleniyor
            if(get_paymethod.due_start_month gt 0){
                due_date_ =DateAdd("m",get_paymethod.due_start_month,due_date_);
            }
    
            //vade başlangıcına belirtilen gün ekleniyor
            if(get_paymethod.due_start_day gt 0){
                due_date_ =DateAdd("d",get_paymethod.due_start_day,due_date_);
            }
            
            //vade ay sonu başlasın seçili ise gelen tarihin olduğu ayın son günü bulunur
            if(get_paymethod.IS_DUE_ENDOFMONTH eq 1){
                daymount = DaysInMonth(due_date_);
                Day= Day(due_date_);
                due_date_ =DateAdd("d",daymount-Day,due_date_);
            }
			
			//vade ay başı başlasın seçili ise gelen tarihin olduğu ayın ilk günü bulunur
            if(get_paymethod.IS_DUE_BEGINOFMONTH eq 1){
				Day= Day(due_date_);
				due_date_ =  DateAdd("d",(Day-1)*-1,due_date_);
            }

            //ortalama vadeye girilen gün vadeye ekleniyor
            if(len(get_paymethod.due_day)){
                if(get_paymethod.IS_BUSINESS_DUE_DAY){
                    j=1;
                    while(j le get_paymethod.due_day){
                        due_date_= dateAdd("d",1,due_date_);
                        if(dayOfWeek(due_date_) neq 7 and dayOfWeek(due_date_) neq 1 ){                       
                            myQuery = queryExecute(
                                    "SELECT OFFTIME_ID FROM #dsn_alias#.SETUP_GENERAL_OFFTIMES
                                    WHERE FINISH_DATE >= #due_date_# 
                                        AND START_DATE <= #due_date_# and (IS_HALFOFFTIME = 0 OR IS_HALFOFFTIME IS NULL)", 
                                    {}, 
                                    {datasource = "#arguments.transaction_dsn#"} 
                                );
                            if(not len(myQuery.OFFTIME_ID))
                                j++;
                        }
                    }
                }
                else{
                    due_date_ =DateAdd("d",get_paymethod.due_day,due_date_);
                }
            }
        }

        //sonraki x günü olsun denildi ise o hesaplanıyor
        if(get_paymethod.next_day gt 0){
            Dayofweek= DayOfWeek(due_date_);
            if(Dayofweek neq get_paymethod.next_day){
                days = get_paymethod.next_day - Dayofweek;
                if(days gt 0){
                    result.next_day = 1;
                    due_date_ =DateAdd("d",days,due_date_);
                }else if(days lt 0){
                    result.next_day = 1;
                    days = 7+days;
                    due_date_ =DateAdd("d",days,due_date_);
                }
            }
        }
        </cfscript>

        <cfif get_paymethod.IS_DATE_CONTROL eq 1>
            <!--- Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin seçili ise vade tarihi erteleniyor --->
            <cfquery name="get_setup_general_offtimes" datasource="#arguments.transaction_dsn#">
                SELECT DATEDIFF(day,#due_date_#,FINISH_DATE) AS FARK,START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM #dsn_alias#.SETUP_GENERAL_OFFTIMES WHERE FINISH_DATE >= #due_date_# AND START_DATE <= #due_date_#
            </cfquery>
            <cfif get_setup_general_offtimes.recordcount>
                <cfset due_date_ = DateAdd('d',get_setup_general_offtimes.FARK+1 ,due_date_)>
                <cfset result.isholiday = 1>
            </cfif>
            <cfset vade_gun = DayOfWeek(due_date_)>
            <cfif vade_gun eq 7>
                <cfset result.isholiday = 1>
                <cfset due_date_ = DateAdd("d", 2, due_date_)> 
            <cfelseif vade_gun eq 1>
                <cfset result.isholiday = 1>
                <cfset due_date_ = DateAdd("d", 1, due_date_)>
            </cfif>
        </cfif>
        <cfset result.due_date = dateformat(due_date_,dateformat_style)>

        <cfset result.daydiff = dateDiff('d',arguments.action_date,due_date_)>

        <cfif isdefined("arguments.isAjax") and len(arguments.isAjax)>
            <cfset result = serializeJSON(result)>
            <cfset result = reReplace(result,"//","","ALL")>
            <cfset writeOutput(result)>
        <cfelse>
            <cfreturn result> 
        </cfif>

    </cffunction>
</cfcomponent>