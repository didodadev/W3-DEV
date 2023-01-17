

 <cfobject name="stretching_test" component="addons.n1-soft.textile.cfc.stretching_test">
   
   
    <cfscript>
		test_date='#now()#';
		if(isdefined("caller.attributes.project_id") and len(caller.attributes.project_id))
			project_id=caller.attributes.project_id;
		else
			project_id="";
		if(isdefined("caller.attributes.order_id") and len(caller.attributes.order_id))
			order_id=caller.attributes.order_id;
		else	
			order_id="";
		
		if(len(project_id))
		{
				getResult=stretching_test.get_stretching_test_by_opp(
					purchasing_id:attributes.action_id,
					project_id:project_id
				);
				
				if(getResult.recordcount eq 0)
				{
					addResult=stretching_test.add_stretching_test
					(
						test_date:test_date,
						author_id:session.ep.userid,
						project_id:project_id,
						//order_id:order_id,
						employee_id:session.ep.userid,
						purchasing_id:attributes.action_id,
						fabric_arrival_date:test_date
					);
				}
		}
    </cfscript>