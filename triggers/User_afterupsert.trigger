trigger User_afterupsert on User (after insert, after update) {

    Set<id> lsUser = new Set<id>(); // List of users where the public groups have to be set
    List<id> lsUserGrpAll = new List<id>(); // List of users where the All public group has to be set

    List<id> lsUserAccessJPAccountAdd = new List<id>(); // List of users where the public group All_Japan_Users have to be set
    List<id> lsUserAccessJPAccountDel = new List<id>(); // List of users where the public group All_Japan_Users have to be removed

    Set<Id> lsProfilesIdOK = new Set<Id>();
    for (Profile prof : [Select Id from Profile where UserType = 'Standard']) {
        lsProfilesIdOK.add(prof.Id);
    }
    
    if (Trigger.isInsert) {
        // The user should be added if there is some SalesArea specified
        For (User usr : Trigger.new)
        {
            if (usr.IsActive && lsProfilesIdOK.contains(usr.ProfileId)) {
                if (usr.SalesArea__c != null) {
                    lsUser.add(usr.id);
                } else {
                    lsUserGrpAll.add(usr.id);
                }                
            }

            if (usr.IsActive && lsProfilesIdOK.contains(usr.ProfileId) && usr.HasAccessJapanAccountContact__c) {
                lsUserAccessJPAccountAdd.add(usr.id);
            } 
        }
    } 

    if (Trigger.isUpdate) { 
        // The user should be added if the SalesArea has changed
        For (User usr : Trigger.new)
        {
            if (usr.IsActive && lsProfilesIdOK.contains(usr.ProfileId)) {
                if (usr.SalesArea__c != Trigger.oldMap.get(usr.Id).SalesArea__c) { 
                    lsUser.add(usr.id);
                }
                if (usr.SalesArea__c == null) {
                    lsUserGrpAll.add(usr.id);
                }
            }

            if (usr.IsActive && lsProfilesIdOK.contains(usr.ProfileId) && (usr.HasAccessJapanAccountContact__c != Trigger.oldMap.get(usr.Id).HasAccessJapanAccountContact__c ||
                                                                           usr.IsActive != Trigger.oldMap.get(usr.Id).IsActive)) { 
                if (usr.HasAccessJapanAccountContact__c) {
                    lsUserAccessJPAccountAdd.add(usr.id);
                } else {
                    lsUserAccessJPAccountDel.add(usr.id);
                }
            }

        }
    }
    
    if (lsUser != null && lsUser.size() > 0)
    {
        // Delete the already selected groups
        if (Trigger.isUpdate) {
            List<GroupMember> lsGrpMbr = [Select Id From GroupMember WHERE Group.DeveloperName LIKE 'SalesArea_%' and UserOrGroupId in :lsUser];
            delete lsGrpMbr;
        }

        // Get the list of the public groups
        Map<String, id> mpGroups = new Map<String, id>();
        For(Group grp : [Select Id, Name, DeveloperName, Type From Group WHERE Type = 'Regular' and DeveloperName LIKE 'SalesArea_%'])
        {
            mpGroups.put(grp.DeveloperName.right(3), grp.id);
        }

        // Get the list of Group Member to be added
        List<GroupMember> lsGrpMbrToAdd = new List<GroupMember>();
        For (User usr : Trigger.new)
        {
            if (usr.IsActive && lsProfilesIdOK.contains(usr.ProfileId) && lsUser.contains(usr.id) && usr.SalesArea__c != null && usr.SalesArea__c.length() > 0) { 

                List<String> lsSalesArea = usr.SalesArea__c.split(';');
                if(lsSalesArea.size() > 0) {
                    For (String sSalesArea : lsSalesArea)
                    {
                        If (mpGroups.containsKey(sSalesArea)) {
                            lsGrpMbrToAdd.add(new GroupMember(GroupId = mpGroups.get(sSalesArea), UserOrGroupId = usr.id));
                        }
                    }
                }
            }
        }
        
        If (lsGrpMbrToAdd != null && lsGrpMbrToAdd.size() > 0) {
            insert lsGrpMbrToAdd;
        }

    }




    if (lsUserGrpAll != null && lsUserGrpAll.size() > 0)
    {

        // Get the id of the all public group
        id idGrpAll = [Select Id, Name, DeveloperName, Type From Group WHERE Type = 'Regular' and DeveloperName = 'SalesArea_All'].id;

        // Get the list of Group Member to be added
        List<GroupMember> lsGrpMbrToAdd = new List<GroupMember>();
        For (id usrid : lsUserGrpAll)
        {
            lsGrpMbrToAdd.add(new GroupMember(GroupId = idGrpAll, UserOrGroupId = usrid));
        }
        
        If (lsGrpMbrToAdd != null && lsGrpMbrToAdd.size() > 0) {
            insert lsGrpMbrToAdd;
        }

    }

    // Remove the All_Japan_Users public group
    if (lsUserAccessJPAccountDel != null && lsUserAccessJPAccountDel.size() > 0) {
        List<GroupMember> lsGrpMbr = [Select Id From GroupMember WHERE Group.DeveloperName = 'All_Japan_Users' and UserOrGroupId in :lsUserAccessJPAccountDel];
        delete lsGrpMbr;
    }

    // Add the All_Japan_Users public group
    if (lsUserAccessJPAccountAdd != null && lsUserAccessJPAccountAdd.size() > 0) {

        // Get the id of the all public group
        id idGrpAllJapanUsers = [Select Id, Name, DeveloperName, Type From Group WHERE Type = 'Regular' and DeveloperName = 'All_Japan_Users'].id;

        // Get the list of Group Member to be added
        List<GroupMember> lsGrpMbrToAdd = new List<GroupMember>();
        For (Id usrId : lsUserAccessJPAccountAdd) {
            lsGrpMbrToAdd.add(new GroupMember(GroupId = idGrpAllJapanUsers, UserOrGroupId = usrId));
        }
        
        If (lsGrpMbrToAdd != null && lsGrpMbrToAdd.size() > 0) {
            insert lsGrpMbrToAdd;
        }

    }

}