#Server core and Clustering/Storage scripts

You will need to set your interfaces first:

my scripts use SAN1, SAN2 for san storage with iscsi
host1,host2 (etc) for teamed connection
guest1,guest2 (etc) for the teamed hyper-v interface

quick way is:
get-netadapter, rename-netadapter "oldname" "newname"

After that in order:

clusternode_serviceinstall_core - this will ask to set your SAN IPs for those interfaces, if you have more or labelled different, adjust them.
network_and_storage_core - this is for setting up your teams, your ISCSI group ip's, adding storage (config your san prior and slice up a lun/whatever).

BuildCluster_Add_CSV - Build out your cluster and add the CSV storage


Run them in this order, change what you need.