<cfscript>
    CounterMeter = createObject("component", "V16.sales.cfc.counter_meter");
    CounterMeter.delete(
        cm_id : attributes.cm_id
    );
</cfscript>