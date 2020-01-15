({
	doInit: function(cmp) {
        var recordId = cmp.get("v.recordId");
        
        var action = cmp.get("c.doCreateJob");
		action.setParams({ orderId : recordId }); 
		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()[0].indexOf('Error') != -1) {
                    cmp.set("v.statusMsg", response.getReturnValue()[0]);
                } else {
                    var toggleText = cmp.find("main");
                    $A.util.toggleClass(toggleText, "toggle");
                    cmp.set("v.statusMsg", "The Job " + response.getReturnValue()[1] + " has been created.");
                    cmp.set("v.jobId", response.getReturnValue()[0]);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set("v.statusMsg", "Error: " + errors[0].message);
                    }
                } else {
                    cmp.set("v.statusMsg", "Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },
    
    goToJobDetailPage: function(cmp) {
        var jobUrl = 'https://new.skedulo.com/jobdetails/';
        var win = window.open(jobUrl + cmp.get('v.jobId'), '_blank');
        win.focus();
    },
    
    onRefreshParent: function(cmp) {
        $A.get("e.force:closeQuickAction").fire();
    }
})