#create the virtual dataset
$c->{datasets}->{dark} = {
	sqlname => "eprint",
	virtual => 1,
	class => "EPrints::DataObj::EPrint",
	confid => "eprint",
	import => 1,
	index => 1,
	order => 1,
	filters => [ { meta_fields => [ 'eprint_status' ], value => 'dark', describe => 0 } ],
	dataset_id_field => "eprint_status",
	datestamp => "lastmod",
};

#add the extra option to the eprint_status field
push @{$c->{fields}->{eprint}},
	{
        	name => 'eprint_status',
	        type => 'set',
        	options => [qw(
                	inbox
	                buffer
	                archive
			deletion
			dark
	        )],
		replace_core => 1
	},
;

#manage deposits filters
$c->{items_filters_order} = [qw/ inbox buffer archive deletion dark /];
$c->{items_filters} = [ inbox => 1, buffer => 1, archive => 0, deletion => 0, dark => 0 ];

# Dark Archive
$c->{roles}->{"own-dark"} = [
        "eprint/dark/view:owner",
        "eprint/dark/summary:owner",
];

$c->{roles}->{"edit-dark"} = [
        "eprint/buffer/move_dark:editor",
        "eprint/dark/view:editor",
        "eprint/dark/summary:editor",
        "eprint/dark/move_buffer:editor",
];

push @{$c->{user_roles}->{user}}, qw{
        own-dark
};

push @{$c->{user_roles}->{editor}}, qw{
        own-dark
	edit-dark
};

push @{$c->{user_roles}->{admin}}, qw{
        own-dark
	edit-dark
};
