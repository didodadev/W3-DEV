<cfif isDefined("attributes.pid")>
	<cfset total=0>
  	<cfquery name="GET_INVOICE_ID_IN" datasource="#DSN2#">
		SELECT 
			IR.INVOICE_ID,
			IR.AMOUNT,
			IR.PRICE,
			PU.MULTIPLIER 
		FROM 
			INVOICE_ROW IR,
			#dsn3_alias#.PRODUCT_UNIT PU
		WHERE 
			IR.PURCHASE_SALES = 0 AND 		 
			IR.PRODUCT_ID = #attributes.pid# AND		
			IR.PRODUCT_ID = PU.PRODUCT_ID AND 
			IR.UNIT = PU.ADD_UNIT
		ORDER BY 
			IR.INVOICE_ID DESC
  </cfquery>
  <cfset IN_LIST="">
  <cfset TOTAL_IN=0>
  <cfoutput query="GET_INVOICE_ID_IN"> 
  	<cfscript>
		PRICE_=PRICE/MULTIPLIER;
		IN_=MULTIPLIER*AMOUNT;
		TOTAL_IN=TOTAL_IN+IN_;
		IN_LIST=LISTAPPEND(IN_LIST,"#IN_#,#PRICE_#");
	</cfscript>
  </cfoutput> 

  <cfquery name="GET_INVOICE_ID_OUT" datasource="#DSN2#">
	SELECT 
		IR.INVOICE_ID, 
		IR.AMOUNT, 
		IR.PRICE, 
		PU.MULTIPLIER 
	FROM 
		INVOICE_ROW IR, 
		#dsn3_alias#.PRODUCT_UNIT PU
	WHERE 
		IR.PURCHASE_SALES = 1 AND 
		IR.PRODUCT_ID=#attributes.pid# AND 
		IR.PRODUCT_ID= PU.PRODUCT_ID AND 
		IR.UNIT = PU.ADD_UNIT
	ORDER BY 
		IR.INVOICE_ID DESC 
  </cfquery>
  <cfset OUT_LIST="">
  <cfset TOTAL_OUT=0>
  <cfoutput query="GET_INVOICE_ID_OUT"> 
  	<cfscript>
		PRICE_=PRICE/MULTIPLIER;
		OUT=MULTIPLIER*AMOUNT;
		TOTAL_OUT=TOTAL_OUT+OUT;
		OUT_LIST=LISTAPPEND(OUT_LIST,"#OUT#,#PRICE_#");
	</cfscript>
  </cfoutput> 
  <cfset TOTAL=TOTAL_IN - TOTAL_OUT>
  <cfif total gt 0>
	<cfset TEMP_LIST="">
	<cfset TEMP_LIST_MONEY="">
	<cfset TEMP_TOTAL=0>
	<cfset TOTAL_EX=0>
	<cfset SAYAC=1>
	<cfloop LIST="#IN_LIST#" index="I">
		<cfscript>
		if (SAYAC MOD 2 EQ 1)
			{
			TEMP_TOTAL =TEMP_TOTAL + I;
			if (TOTAL GT TEMP_TOTAL)
				{
				TOTAL_EX=TOTAL-TEMP_TOTAL;
				TEMP_LIST=LISTAPPEND(TEMP_LIST,I);
				TEMP_LIST_MONEY=LISTAPPEND(TEMP_LIST_MONEY,LISTGETAT(IN_LIST,SAYAC+1));
				}
			else if (SAYAC EQ 1)
				TOTAL_EX=TOTAL;
			}
		SAYAC=SAYAC+1;
		</cfscript>
	</cfloop>
	<cfscript>
		TEMP_LEN=(LISTLEN(TEMP_LIST)*2)+2;
		TEMP_LIST=LISTAPPEND(TEMP_LIST,TOTAL_EX);
		TEMP_LIST_MONEY=LISTAPPEND(TEMP_LIST_MONEY,LISTGETAT(IN_LIST,TEMP_LEN));
		nettotal=0;
		for (i=1; i lte listlen(temp_list_money); i=i+1)
			nettotal=nettotal+(listgetat(temp_list,i)*listgetat(temp_list_money,i));
	</cfscript>
  <cfelse>
    <cfset nettotal=0>
  </cfif>
</cfif>
