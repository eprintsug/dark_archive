package EPrints::Plugin::Screen::EPrint::DarkMove;

@ISA = ( 'EPrints::Plugin::Screen::EPrint' );

use strict;

sub new
{
	my( $class, %params ) = @_;

	my $self = $class->SUPER::new(%params);

	$self->{actions} = [qw/ move_dark /];

	$self->{appears} = [
                { place => "eprint_editor_actions", action => "move_dark", position => 2000, },
                { place => "eprint_actions_editor_buffer", action => "move_dark", position => 400, },
                { place => "eprint_actions_editor_dark", action => "move_buffer", position => 100, },
        ]; 

	return $self;
}

sub allow_move_dark
{
	my( $self ) = @_;

	my $epversion = $self->{session}->get_repository->get_conf( "version_id" );
	if( EPrints::Utils::is_set( $epversion ) && $epversion =~ /^eprints\-3\.(\d+)\./ )
	{
		my $minor = $1;
		if( $minor >= 2 )
		{
			# EPrints 3.2: need to take the edit lock into consideration:
			return 0 unless $self->could_obtain_eprint_lock;
		}
	}
	return $self->allow( "eprint/move_dark" );
}

sub action_move_dark
{
	my( $self ) = @_;

	my $ok = $self->{processor}->{eprint}->_transfer( "dark" );

	$self->add_result_message( $ok );
}

sub add_result_message
{
        my( $self, $ok ) = @_;

        EPrints::Plugin::Screen::EPrint::Move::add_result_message( $self, $ok );
} 

1;
