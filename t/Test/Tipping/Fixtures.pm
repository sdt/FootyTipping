package Test::Tipping::Fixtures;

use Modern::Perl::5_14;
use Carp                qw/ croak /;
use Moose;
use namespace::autoclean;

has schema => (
    is  => 'ro',
    isa => 'Tipping::Schema',
);

sub competition {
    my ($self, %args) = @_;

    return $self->schema->resultset('Competition')->create({
            name     => $args{name} // _gen_name('comp'),
            password => $args{password},
        });
}

sub user {
    my ($self, %args) = @_;

    my $user = $self->schema->resultset('User')->create({
            _opt_arg(\%args, 'username'),
            _opt_arg(\%args, 'password'),
            _opt_arg(\%args, 'real_name'),
            _opt_arg(\%args, 'email'),
        });

    if (my $comps = $args{competitions}) {
        for my $comp (ref $comps ? @$comps : ( $comps )) {
            $user->add_to_competitions($comp);
        }
    }

    return $user;
}

sub _check_param {
    my ($args, $key);
    return $args->{$key} or croak 'Missing mandatory parameter: ' . $key;
}

sub _opt_arg {
    my ($args, $key) = @_;
    return $key => $args->{$key} // _gen_name($key);
}

sub _gen_name {
    my ($fragment) = @_;
    state $next_id = 1;
    return sprintf('test_%s_%04d', $fragment, $next_id++);
}

__PACKAGE__->meta->make_immutable;
1;
