<cfscript>
    component {
        
        property struct requestContainer;
        property struct sessionContainer;
        property struct applicationContainer;

        
        public any function init() {
            if (isDefined("request.container")) {
                this.requestContainer = request.container;
            } else {
                this.requestContainer = {};
                request.container = this.requestContainer;
            }
            if (isDefined("session.container")) {
                this.sessionContainer = session.container;
            } else {
                this.sessionContainer = {};
                session.container = this.sessionContainer;
            }
            if (isDefined("application.container")) {
                this.applicationContainer = application.container;
            } else {
                this.applicationContainer = {};
                application.container = this.applicationContainer;
            }
            return this;
        }

        /* Unscoped */
        
        public any function resolveTransient(required string namespace, string type = "component", boolean hasInit = 0, any initializer = 0) {
            if (hasInit) {
                if (initializer eq 0) {
                    resolved = createObject(type, namespace).init();
                } else {
                    resolved = createObject(type, namespace).init(initializer);
                }
            } else {
                resolved = createObject(type, namespace);
            }
            return resolved;
        }

        /* Application */

        public any function resolveByApplication(required string namespace, string type = "component", boolean hasInit = 0, any initializer = 0) {
            if (structKeyExists(this.applicationContainer, namespace)) {
                return this.applicationContainer[namespace];
            } else {
                this.applicationContainer[namespace] = resolveTransient(namespace, type, hasInit, initializer);
                return this.applicationContainer[namespace];
            }
        }

        public any function hasRegisteredInApplication(required string namespace)
        {
            return structKeyExists(this.applicationContainer, namespace);
        }

        public any function registerToApplication(required string namespace, required any instance) {
            if (structKeyExists(this.applicationContainer, namespace)) throw(message= "You cannot register an exists instance!");
            this.applicationContainer[namespace] = instance;
        }

        
        public any function destroyInApplication(required string namespace) {
            if (structKeyExists(this.applicationContainer, namespace)) {
                structDelete(this.applicationContainer, namespace);
            }
        }

        /* Session */
        
        public any function resolveBySession(required string namespace, string type = "component", boolean hasInit = 0, any initializer = 0) {
            if (structKeyExists(this.sessionContainer, namespace)) {
                return this.sessionContainer[namespace];
            } else {
                this.sessionContainer[namespace] = resolveTransient(namespace, type, hasInit, initializer);
                return this.sessionContainer[namespace];
            }
        }

        public any function hasRegisteredInSession(required string namespace)
        {
            return structKeyExists(this.sessionContainer, namespace);
        }

        public any function registerToSession(required string namespace, required any instance) {
            if (structKeyExists(this.sessionContainer, namespace)) throw(message= "You cannot register an exists instance!");
            this.sessionContainer[namespace] = instance;
        }

        
        public any function destroyInSession(required string namespace) {
            if (structKeyExists(this.sessionContainer, namespace)) {
                structDelete(this.sessionContainer, namespace);
            }
        }

        /* Request */

        public any function resolveByRequest(required string namespace, string type = "component", boolean hasInit = 0, any initializer = 0) {
            if (structKeyExists(this.requestContainer, namespace)) {
                return this.requestContainer[namespace];
            } else {
                this.requestContainer[namespace] = resolveTransient(namespace, type, hasInit, initializer);
                return this.requestContainer[namespace];
            }
        }

        public any function hasRegisteredInRequest(required string namespace)
        {
            return structKeyExists(this.applicationContainer, namespace);
        }

        public any function registerToRequest(required string namespace, required any instance) {
            if (structKeyExists(this.requestContainer, namespace)) throw(message= "You cannot register an exists instance!");
            this.requestContainer[namespace] = instance;
        }

        
        public any function destroyInRequest(required string namespace) {
            if (structKeyExists(this.requestContainer, namespace)) {
                structDelete(this.requestContainer, namespace);
            }
        }

    }
</cfscript>