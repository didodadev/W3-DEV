/*!
 * Ext JS Library 3.0.0
 * Copyright(c) 2006-2009 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.onReady(function(){
	
	//This function will be called on a succesful load, it can be used for debugging or perform on load events.
	function testStore(st,recs,opts){		
        //console.info('Store count = ', store.getCount());        	
	}
	
	//This is our JSON record set which defines what kind of data will be present in the JSON passed back from our component.
	var users = Ext.data.Record.create([
	{name:'ID',type:'int'},
	{name:'FIRSTNAME',type:'string'},
	{name:'LASTNAME',type:'string'},
	{name:'DISPLAYNAME',type:'string'},
	{name:'USERNAME',type:'string'},
	{name:'USERACCOUNTINGCODE',type:'string'},
	{name:'PHONE',type:'string'}
	])
	
    // create the Data Store
    var store = new Ext.data.JsonStore({
    	totalProperty:'DATASET',//This is how many total records are there in the set.
    	root:'ROWS',//The Root of the data.
        url:'http://coldfusion-ria.com/Blog/KSPersonal/getStuff.cfc',//Where we get it from
        remoteSort:true,//We will sort server side
        //Base Params are parameters passed in during the first call
        baseParams:{
            	method: 'getStuffA',
            	returnFormat: 'JSON',
            	start: '0',
            	limit: '50'
            },
        //We define the JSON Reader for the data. We also need to set the totalProperty, root and idProperty for the dataset here.
        reader: new Ext.data.JsonReader({
        		totalProperty:'DATASET',
        		root:'ROWS',
        		idProperty:'ID'      	
        	},users
        ),
        //Fields read in
        fields: [
            'ID','FIRSTNAME','LASTNAME','DISPLAYNAME','USERNAME','USERACCOUNTINGCODE','PHONE'
        ],
        //We specify the listeners to be called during load or another one during loadexception. good for debugging purposes.
        listeners: {
                load:{
                	fn: testStore
                },
                loadexception: {
                	fn: function() {
                    	//console.log(arguments);
                    	//console.info("Response Text?"+response.responseText);
                    	//console.log("dgStore Message \n"+proxy+"\n"+store+"\n"+response+"\n"+e.message);
                	}
                }
            }
    });
   //We setup the Grid
  	var grid = new Ext.grid.GridPanel({
        width:750,
        height:500,              
        title:'Users',
        store: store,
        trackMouseOver:true,
        disableSelection:false,
        loadMask: true,
		stripRows: true,
		collapsible: true,
        // grid columns
        columns:[
        new Ext.grid.RowNumberer(),//This will do numbering on the grid for us
        {
            id: 'users', 
            header: "First Name",
            dataIndex: 'FIRSTNAME',
            width: 125,
            hidden:false,            
            sortable: true
        },{
            header: "Last Name",
            dataIndex: 'LASTNAME',
            width: 125,
            hidden: false,
            sortable: true
        },{
            header: "Display Name",
            dataIndex: 'DISPLAYNAME',
            width: 200,
            hidden: false,
            sortable: true
        },{
            header: "User Name",
            dataIndex: 'USERNAME',
            width: 125,
            hidden: false,
            sortable: true
        },{
            header: "Contact",
            dataIndex: 'PHONE',
            width: 100,
            hidden: false,
            sortable: true
        }],

       // paging bar on the bottom
       bbar: new Ext.PagingToolbar({
            pageSize: 50,
            store: store,
            displayInfo: true,
            displayMsg: 'Displaying Records {0} - {1} of {2}',
            emptyMsg: "No Records to display"            
        })
    });
	
	//Default Sort set for the grid load call
	store.setDefaultSort('FIRSTNAME','ASC');
    // render it
    grid.render('topic-grid');

    // trigger the data store load
    store.load();
});
// JavaScript Document