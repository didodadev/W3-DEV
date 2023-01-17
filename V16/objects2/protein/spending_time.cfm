<cfset getComponent = createObject('component','V16.project.cfc.get_work')>
<cfset get_time_history = getComponent.get_time_history(id:attributes.wid)>
<div class="row mb-3">
    <div class="col-md-12">               
        <h6 class="header-color"><cf_get_lang dictionary_id='57561.Zaman Harcamaları'></h6>
    </div>
</div>  
<cfset total_h = 0>
<cfset total_m = 0>
<cfoutput query="get_time_history">    
<div class="row mb-2">
    <div class="col-md-12 d-flex justify-content-between flex-wrap">
        <label class="w-75"><cfif type eq 'employee'>#get_emp_info(employee_id,0,0)#<cfelse>#get_par_info(employee_id,0,-1,0)#</cfif></label>                   
        <label>
            <cfset total_time_1 = 0>                                                        
            <cfif len(TOTAL_TIME_HOUR)>
                <cfset total_time_1 = TOTAL_TIME_HOUR * 60>                                                        
                <cfset minute_1 = total_time_1 / 60>
            </cfif>
            <cfif len(TOTAL_TIME_MINUTE)>
                <cfset total_time_2 = TOTAL_TIME_MINUTE * 60>
                <cfset minute_2 = total_time_2 / 60>                                                        
                <cfset total_time_end = total_time_1 + TOTAL_TIME_MINUTE>
                <cfset totaltime_ = total_time_end mod 60>
            <cfelse>
                <cfset total_time_end = 0>
                <cfset totaltime_ = 0>
            </cfif>
            <cfset total_h = total_h + ((total_time_end - totaltime_)/60)>    
            <cfset total_m = total_m + totaltime_>    
            #((total_time_end - totaltime_)/60)#h #totaltime_#m
        </label>
    </div>
</div>
</cfoutput>
<div class="row mt-3">
    <div class="col-md-12 d-flex justify-content-between flex-wrap">
        <label class="font-weight-bold w-75"><cf_get_lang dictionary_id='61930.Toplam Zaman'></label>                   
      <cfoutput>  <label class="font-weight-bold">#total_h# h #total_m# m</label></cfoutput>
    </div>
</div>
