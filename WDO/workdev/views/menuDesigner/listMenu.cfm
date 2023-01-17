<div class="col col-12 col-md-12 col-sm-12 col-xs-12"  id="design-app-list">
    <div id="alertMessage"></div>
    <cf_box title="Menus" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <tr>
                <th width="30">No</th>
                <th>Menu Name</th>
                <th>Record Date</th>
                <th>Author</th>
                <th width="20"> <a href="<cfoutput>#request.self#?fuseaction=dev.menudesigner&event=add</cfoutput>"><i class="fa fa-plus"></i></a></th>
                <th width="20"> <a href=""><i class="fa fa-minus"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>0</td>
                    <td>Standart</td>
                    <td></td>
                    <td>Workcube</td>
                    <td><a href="<cfoutput>#request.self#?fuseaction=dev.menudesigner</cfoutput>&event=mm"><i class="fa fa-pencil"></i><a></td>
                        <td></td>
                </tr>
                <tr v-for="item in menus"  v-bind:data-id="item[0]">
                    <td>{{ item[0] }}</td>
                    <td>{{ item[1] }}</td>
                    <td>{{ item[2] }}</td>
                    <td>{{ item[3] }}</td>
                    <td><a :href="'<cfoutput>#request.self#?fuseaction=dev.menudesigner</cfoutput>&event=upd&menu='+item[0]"><i class="fa fa-pencil"></i><a></td>
                        <td><i class="fa fa-minus" @click="deleteConfirm(item[0],item[1],item[3] )"></i></td>
                </tr>
            </tbody>
        </cf_flat_list>
        <div class="modal fade" id="deleteConfirm" tabindex="-1" role="dialog" aria-labelledby="labelConfirm" aria-hidden="true">
            <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-white border-0">
                <h5 class="modal-title text-muted" id="labelConfirm"><i class="far fa-trash-alt"></i> {{delMenu[0].name}}</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                </div>
                <div class="modal-body">
                    <p class="h5 text-secondary">Delete This Menu?</p>
                    
                    
                </div>
                <div class="modal-footer">
                <small class="text-muted"><i class="fas fa-user-edit"></i> {{delMenu[0].author}}</small>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" @click="deleteMenu(delMenu[0].id)">Delete</button>
                </div>
            </div>
            </div>
        </div>
    </cf_box>
</div>

<script>
var wmdl = new Vue({
        el: '#design-app-list',
        data: {
            menus: [],
            error: [],
            msg : 'test',
            delMenu:[{
                id:'',
                name:'',
                author:''
            }]
        },
        methods:{
            deleteConfirm : function(id,name,author){
                this.delMenu[0].id=id;
                this.delMenu[0].name=name;
                this.delMenu[0].author=author;
                $('#deleteConfirm').modal('show');
            },
            deleteMenu : function(id){
                axios
                    .get( "/WDO/workdev/cfc/menuDesigner.cfc", {params: {method : 'DEL_MENU', MENU_ID:id}})
                    .then(response => {
                        if(response.data = 500){
                            $('#deleteConfirm').modal('hide');
                            $('tr[data-id="'+id+'"]').remove();
                            alertObject({message:'Menü Silindi',container:'alertMessage',type:"success"});

                        }
                    })
                    .catch(e => {wmdl.error.push({ecode: 701, message: 'delete menu'}) });
            }
        },      
        mounted () {
            axios
                .get( "/WDO/workdev/cfc/menuDesigner.cfc", {params: {method : 'GET_MENUS'}})
                .then(response => {wmdl.menus = response.data.DATA;})
                .catch(e => {wmdl.error.push({ecode: 700}) });
        }      
    })
</script>