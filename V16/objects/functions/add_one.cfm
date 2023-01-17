<cfscript>
	function add_one(gelen)
	{
		elde = 0;
		uz = len(gelen);
		for (i=uz; i gt 0;i=i-1)
			{
			eleman = mid(gelen,i,1);
	
			if ( (i eq uz) or (elde) )
				eleman = eleman + 1;
	
			if (eleman gt 9)
				elde = 1;
			else
				elde = 0;
	
			if (i eq 1)
				{
				if (elde)
					bas = '1';
				else
					bas = '';
				}
			else
				bas = left(gelen,i-1);
			
			if (i neq uz)
				son = right(gelen,uz-i);
			else
				son = '';
				
			gelen = '#bas##right(eleman,1)##son#';
			if (not elde)
				return gelen;
			}
		return gelen;
	}
</cfscript>

