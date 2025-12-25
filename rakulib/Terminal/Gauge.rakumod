unit module Gauge:ver<0.1.0>:auth<Francis Grizzly Smit (grizzly@smit.id.au)>;

#use Terminal::ANSI::OO :t;
#use Terminal::Width;
use Terminal::WCWidth;
#use Term::termios;
use Term::ReadKey:from<Perl5>;
use Terminal::ANSIColor;

=begin pod

=head1 Terminal::Gauge

=begin head2

Table of Contents

=end head2

=item1 L<NAME|#name>
=item1 L<AUTHOR|#author>
=item1 L<VERSION|#version>
=item1 L<TITLE|#title>
=item1 L<SUBTITLE|#subtitle>
=item1 L<COPYRIGHT|#copyright>
=item2 # L«sub backup-device-val(--> Str) is export|#sub-backup-device-val---str-is-export»
=item1 # L<Introduction|#introduction>
=item2 # L<Example|#example>

=NAME Terminal::Gauge
=AUTHOR Francis Grizzly Smit (grizzly@smit.id.au)
=VERSION 0.1.0
=TITLE Terminal::Gauge.rakumod
=SUBTITLE A B<Raku> module that supports ANSI colour terminal progress gauges.

=COPYRIGHT
LGPL V3.0+ L<LICENSE|https://github.com/grizzlysmit/GUI-Editors/blob/main/LICENSE>

L<Top of Document|#table-of-contents>

=head1 Introduction

A B<Raku> module that supports ANSI colour terminal progress gauges. 
This module utilises ANSI escape sequences to colour and manipulate the output
it reserves either the bottom row of the terminal C«init-term()» 
(or C«init-term(Bars::One)») or it will reserve the bottom 2 rows C«init-term(Bars::Two)»
for the gauge or gauges then calls to C«progress-bar(Str:D $prfix, Int:D $current, Int:D $length --> Bool)» and in the case of C«init-term(Bars::Two)»
C«sub-progress-bar(...)» will update the progress bars, C«progress-bar(Str:D $prfix, Int:D $current, Int:D $length --> Bool)» will put it's gauge 
on the bottom line and C«sub-progress-bar(Str:D $prfix, Int:D $current, Int:D $length --> Bool)» writes to the line above in the C«init-term(Bars::Two)»
case,  finally the C«deinit-term(Int:D $sig)» function removes the progress bars and makes the bottom lines part of the 
normal scrollable region of the terminal again.

=head2 Example

=begin code :lang<raku>

sub do-progress-bar(...) {
    # set the progress bar colours and chars  #
    # this is optional as reasonable defaults #
    # are provided                            #
    set-bar-char($bar-char);
    set-empty-char($empty-char);
    set-prefix-foreground($prefix-foreground);
    set-prefix-background($prefix-background);
    set-gauge-foreground($gauge-foreground);
    set-gauge-background($gauge-background);
    set-suffix-foreground($suffix-foreground);
    set-suffix-background($suffix-background);
    set-sub-bar-char($sub-bar-char);
    set-sub-empty-char($sub-empty-char);
    set-sub-gauge-foreground($sub-gauge-foreground);
    set-sub-gauge-background($sub-gauge-background);
    set-sub-suffix-foreground($sub-suffix-foreground);
    set-sub-suffix-background($sub-suffix-background);
    # .
    # .
    # .
    # .

    # set up the code to insure clean up in all cases we can # 
    LEAVE {
        deinit-term(0);
    }
    init-term(Bars::Two);
    my &call-progress-bar = {
        sub-progress-bar("$current-host: ");
        progress-bar(" Total: ");
    };
    signal(SIGWINCH).tap( { &init-term(Bars::Two),  &call-progress-bar(); } );
    # .
    # .
    # .
    # .
    # Initialise the length of the main gauge #
    set-length((@dirs + @files + 2 * @hosts) * @hosts.grep( { $_ ne $thishost } ));
    init-place(); # intialiase the gauges value must still be past in  #
    progress-bar(" Total: "); # display the main progress bar #
    for @hosts -> $host {
        if $host eq $thishost {
            say "$thishost.local <---> $host.local: skipped";
        } elsif ! shell("ping -c 1 $host.local > /dev/null 2>&1 ") {
            say "$host.local does not exist  or is down";
            say "$thishost.local <---> $host.local: skipped";
        } else {
            # .
            # .
            # .
            # initialise the secondary or inner gauges length #
            set-sub-length(@dirs + @files + 2 * @hosts);
            init-sub-place(); # initialise the place on the sub-gauge or inner-gauge #
            sub-progress-bar("$host: "); # show the secondary progress bar #
            "$thishost.local <---> $host.local".say;
            # .
            # .
            # .
            for @dirs -> $dir {
                # .
                # .
                # .
                inc-sub-place(); # increment the place on the sub progress bar #
                sub-progress-bar("$current-host: "); # refresh the sub progress bar #
                inc-place(); # increment the place on the main progress bar #
                progress-bar(" Total: "); # refresh the main progress bar #
                # .
                # .
                # .
            }
            # .
            # .
            # .
            for @files -> $file {
                # .
                # .
                # .
                inc-sub-place(); # increment the place on the sub progress bar #
                sub-progress-bar("$current-host: "); # refresh the sub progress bar #
                inc-place(); # increment the place on the main progress bar #
                progress-bar(" Total: "); # refresh the main progress bar #
                # .
                # .
                # .
            }
            # .
            # .
            # .
            for @hosts -> $host_inner {
                # .
                # .
                # .
                inc-sub-place(); # increment the place on the sub progress bar #
                sub-progress-bar("$current-host: "); # refresh the sub progress bar #
                inc-place(); # increment the place on the main progress bar #
                progress-bar(" Total: "); # refresh the main progress bar #
                # .
                # .
                # .
                inc-sub-place(); # increment the place on the sub progress bar #
                sub-progress-bar("$current-host: "); # refresh the sub progress bar #
                inc-place(); # increment the place on the main progress bar #
                progress-bar(" Total: "); # refresh the main progress bar #
                # .
                # .
                # .
                # .
                # .
                # .
            } # for @hosts -> $host_inner #
            # .
            # .
            # .
            %results{$host} = %results_catch;
            $result +|= $r;
            "\$r == $r".say;
            dd $result;
        } # end of if else chain #
        sub-progress-bar("$current-host: ", get-sub-length(), get-sub-length()); # show 100% #
    } # for @hosts -> $host #
    progress-bar(" Total: ", get-length(), get-length()); # show full 100% #
    sleep(5); # optional but help the user to see that it  is complete #
    signal().tap({ exit $_ });
}


=end code


=end pod

our @signal is export;

my Bool:D $is-a-terminal = $*OUT.t; # check if stdout $*OUT is a terminal #

sub is-a-terminal( --> Bool:D) is export {
    return $is-a-terminal;
}

my Str:D $BAR-CHAR          = '⧫';
my Str:D $EMPTY-CHAR        = " ";
my Str:D $PREFIX-FOREGROUND = "bold,red";
my Str:D $PREFIX-BACKGROUND = "green";
my Str:D $GAUGE-FOREGROUND  = "bold,red";
my Str:D $GAUGE-BACKGROUND  = "cyan";
my Str:D $SUFFIX-FOREGROUND = "bold,green";
my Str:D $SUFFIX-BACKGROUND = "blue";
my Int:D $length            = 80;
my Int:D $place             = 0;

sub set-bar-char(Str:D $char = '⧫' --> Bool:D) is export {
    if wcswidth($char) != 1 {
        $*ERR.say("Error: BAR-CHAR must be a single char wide!");
        return False;
    }
    $BAR-CHAR = $char;
    return True;
}

sub set-empty-char(Str:D $char = ' ' --> Bool:D) is export {
    if wcswidth($char) != 1 {
        $*ERR.say("Error: EMPTY-CHAR must be a single char wide!");
        return False;
    }
    $EMPTY-CHAR = $char;
    return True;
}

sub set-prefix-foreground(Str:D $value = "bold,red" --> Bool:D) is export {
    $PREFIX-FOREGROUND = $value;
    return True;
}

sub set-prefix-background(Str:D $value = "green" --> Bool:D) is export {
    $PREFIX-BACKGROUND = $value;
    return True;
}

sub set-gauge-foreground(Str:D $value = "bold,red" --> Bool:D) is export {
    $GAUGE-FOREGROUND = $value;
    return True;
}

sub set-gauge-background(Str:D $value = "cyan" --> Bool:D) is export {
    $GAUGE-BACKGROUND = $value;
    return True;
}

sub set-suffix-foreground(Str:D $value = "bold,green" --> Bool:D) is export {
    $SUFFIX-FOREGROUND = $value;
    return True;
}

sub set-suffix-background(Str:D $value = "blue" --> Bool:D) is export {
    $SUFFIX-BACKGROUND = $value;
    return True;
}

sub set-length(Int:D $value where $_ > 0 --> Bool:D) is export {
    $length = $value;
    return True;
}

sub get-length( --> Int:D) is export {
    return $length;
}

sub init-place( --> Bool:D) is export {
    $place = 0;
    return True;
}

sub inc-place( --> Bool:D) is export {
    $place++;
    return True;
}

sub get-place( --> Int:D) is export {
    return $place;
}

my Str:D $SUB-BAR-CHAR          = '◼';
my Str:D $SUB-EMPTY-CHAR        = " ";
my Str:D $SUB-PREFIX-FOREGROUND = "bold,cyan";
my Str:D $SUB-PREFIX-BACKGROUND = "red";
my Str:D $SUB-GAUGE-FOREGROUND  = "bold,green";
my Str:D $SUB-GAUGE-BACKGROUND  = "red";
my Str:D $SUB-SUFFIX-FOREGROUND = "bold,red";
my Str:D $SUB-SUFFIX-BACKGROUND = "cyan";
my Int:D $sub-length            = 80;
my Int:D $sub-place             = 0;

sub set-sub-bar-char(Str:D $char = '◼' --> Bool:D) is export {
    if wcswidth($char) != 1 {
        $*ERR.say("Error: SUB-BAR-CHAR must be a single char wide!");
        return False;
    }
    $SUB-BAR-CHAR = $char;
    return True;
}

sub set-sub-empty-char(Str:D $char = ' ' --> Bool:D) is export {
    if wcswidth($char) != 1 {
        $*ERR.say("Error: SUB-EMPTY-CHAR must be a single char wide!");
        return False;
    }
    $SUB-EMPTY-CHAR = $char;
    return True;
}

sub set-sub-prefix-foreground(Str:D $value = "bold,red" --> Bool:D) is export {
    $SUB-PREFIX-FOREGROUND = $value;
    return True;
}

sub set-sub-prefix-background(Str:D $value = "cyan" --> Bool:D) is export {
    $SUB-PREFIX-BACKGROUND = $value;
    return True;
}

sub set-sub-gauge-foreground(Str:D $value = "bold,green" --> Bool:D) is export {
    $SUB-GAUGE-FOREGROUND = $value;
    return True;
}

sub set-sub-gauge-background(Str:D $value = "red" --> Bool:D) is export {
    $SUB-GAUGE-BACKGROUND = $value;
    return True;
}

sub set-sub-suffix-foreground(Str:D $value = "bold,green" --> Bool:D) is export {
    $SUB-SUFFIX-FOREGROUND = $value;
    return True;
}

sub set-sub-suffix-background(Str:D $value = "blue" --> Bool:D) is export {
    $SUB-SUFFIX-BACKGROUND = $value;
    return True;
}

sub set-sub-length(Int:D $value where $_ > 0 --> Bool:D) is export {
    $sub-length = $value;
    return True;
}

sub get-sub-length( --> Int:D) is export {
    return $sub-length;
}

sub init-sub-place( --> Bool:D) is export {
    $sub-place = 0;
    return True;
}

sub inc-sub-place( --> Bool:D) is export {
    $sub-place++;
    return True;
}

sub get-sub-place( --> Int:D) is export {
    return $sub-place;
}

enum Bars is export (One => 1, Two => 2);

my Bars:D $BARS = Bars::One;

sub progress-bar(Str:D $prfix, Int:D $current = get-place(),
                                             Int:D $length = get-length() --> Bool) is export {
    my Str:D $prefix = "";
    if $is-a-terminal {
        unless wcswidth($prfix) == 0 {
            my @prefix-foreground = $PREFIX-FOREGROUND.split(rx/ \s* ',' \s* /, :skip-empty);
            my @prefix-background = $PREFIX-BACKGROUND.split(rx/ \s* ',' \s* /, :skip-empty).map( { "on_" ~ $_ });
            my @prefix-colour     = @prefix-foreground;
            @prefix-colour.push:  |@prefix-background;
            my $prefix-colour     = color(@prefix-colour.join(" "));
            $prefix ~= $prefix-colour;
            $prefix ~= $prfix;
            $prefix ~= color("reset");
        }
    }
    my Num:D $perc-done = ($current.Num / $length.Num) * 100.Num;
    my Str:D $suffix = sprintf(" %d/%d (%f%%)", $current, $length, $perc-done);
    unless $is-a-terminal {
        say "$prfix: $suffix";
        return False;
    }
    my Int:D ($cols, $rows, $xpixels, $ypixels, @rest) = GetTerminalSize();
    my Int:D $length_   = $cols - wcswidth($prfix) - wcswidth($suffix) - 2;
    my Int:D $num-bars = (($perc-done * $length_.Num)/100.Num).round;
    my @gauge-background = $GAUGE-BACKGROUND.split(rx/ \s* ',' \s* /, :skip-empty);
    my @gauge-foreground = $GAUGE-FOREGROUND.split(rx/ \s* ',' \s* /, :skip-empty);
    my @gauge-colour     = @gauge-foreground;
    @gauge-colour.push: |@gauge-background.map( { "on_" ~ $_ });
    my $gauge-colour = color(@gauge-colour.join(" "));
    my Str:D $line = $prefix;
    $line         ~= "[" ~ $gauge-colour;
    for 0..^$num-bars {
        $line ~= $BAR-CHAR;
    }
    for $num-bars..^$length_ {
        $line ~= $EMPTY-CHAR;
	}
    $line ~= color("reset");
    $line ~= "]";
    my @suffix-foreground = $SUFFIX-FOREGROUND.split(rx/ \s* ',' \s* /, :skip-empty);
    my @suffix-background = $SUFFIX-BACKGROUND.split(rx/ \s* ',' \s* /, :skip-empty).map( { "on_" ~ $_ });
    my @suffix-colour     = @suffix-foreground;
    @suffix-colour.push:  |@suffix-background;
    my $suffix-colour     = color(@suffix-colour.join(" "));
    $line ~= $suffix-colour;
    $line ~= $suffix;
    $line ~= color("reset");
    printf("%s%d", "\e", 7);             # save the cursor location        #
	printf("%s%d;%dH", "\e[", $rows, 0); # move cursor to the bottom line  #
	printf("%s0K", "\e[");               # clear the line                  #
	printf("%s", $line);                 # print the progress bar          #
	printf("%s8", "\e");                 # restore the cursor location     #
    return True;
} #`««« sub progress-bar(Str:D $prfix, Int:D $current = get-place(),
                                             Int:D $length = get-length() --> Bool) is export »»»

sub sub-progress-bar(Str:D $prfix, Int:D $current = get-sub-length(),
                                                    Int:D $length = get-sub-length() --> Bool:D) is export {
    my Str:D $prefix = "";
    if $is-a-terminal {
        unless wcswidth($prfix) == 0 {
            my @sub-prefix-foreground = $SUB-PREFIX-FOREGROUND.split(rx/ \s* ',' \s* /, :skip-empty);
            my @sub-prefix-background = $SUB-PREFIX-BACKGROUND.split(rx/ \s* ',' \s* /, :skip-empty).map( { "on_" ~ $_ });
            my @sub-prefix-colour     = @sub-prefix-foreground;
            @sub-prefix-colour.push:  |@sub-prefix-background;
            my $prefix-colour         = color(@sub-prefix-colour.join(" "));
            $prefix ~= $prefix-colour;
            $prefix ~= $prfix;
            $prefix ~= color("reset");
        }
    }
    my Num:D $perc-done = ($current.Num / $length.Num) * 100.Num;
    my Str:D $suffix = sprintf(" %d/%d (%f%%)", $current, $length, $perc-done);
    unless $is-a-terminal {
        say "$prfix: $suffix";
        return False;
    }
    my Int:D ($cols, $rows, $xpixels, $ypixels, @rest) = GetTerminalSize();
    my Int:D $length_   = $cols - wcswidth($prfix) - wcswidth($suffix) - 2;
    my Int:D $num-bars = (($perc-done * $length_.Num)/100.Num).round;
    my @gauge-background = $SUB-GAUGE-BACKGROUND.split(rx/ \s* ',' \s* /, :skip-empty);
    my @gauge-foreground = $SUB-GAUGE-FOREGROUND.split(rx/ \s* ',' \s* /, :skip-empty);
    my @gauge-colour     = @gauge-foreground;
    @gauge-colour.push: |@gauge-background.map( { "on_" ~ $_ });
    my $gauge-colour = color(@gauge-colour.join(" "));
    my Str:D $line = $prefix;
    $line         ~= "[" ~ $gauge-colour;
    for 0..^$num-bars {
        $line ~= $SUB-BAR-CHAR;
    }
    for $num-bars..^$length_ {
        $line ~= $SUB-EMPTY-CHAR;
	}
    $line ~= color("reset");
    $line ~= "]";
    my @suffix-foreground = $SUB-SUFFIX-FOREGROUND.split(rx/ \s* ',' \s* /, :skip-empty);
    my @suffix-background = $SUB-SUFFIX-BACKGROUND.split(rx/ \s* ',' \s* /, :skip-empty).map( { "on_" ~ $_ });
    my @suffix-colour     = @suffix-foreground;
    @suffix-colour.push:  |@suffix-background;
    my $suffix-colour     = color(@suffix-colour.join(" "));
    $line ~= $suffix-colour;
    $line ~= $suffix;
    $line ~= color("reset");
    printf("%s%d", "\e", 7);                 # save the cursor location                    #
	printf("%s%d;%dH", "\e[", $rows - 1, 0); # move cursor to the second from bottom line  #
	printf("%s0K", "\e[");                   # clear the line                              #
	printf("%s", $line);                     # print the progress bar                      #
	printf("%s8", "\e");                     # restore the cursor location                 #
    return True;
} #`««« sub sub-progress-bar(Str:D $prfix, Int:D $current = get-sub-length(),
                                        Int:D $length = get-sub-length() --> Bool:D) is export »»»

sub init-term(Bars:D $bars = Bars::One) is export {
    $BARS = $bars;
    my %signals = Signal.kv;
    signal(SIGSYS, SIGVTALRM, SIGTTOU, SIGBUS, SIGTERM, SIGPIPE, SIGQUIT,
            SIGPWR, SIGTRAP, SIGHUP, SIGCHLD, SIGXFSZ, SIGXCPU, SIGCONT,
            SIGUSR2, SIGTSTP, SIGPROF, SIGILL, SIGIO, SIGKILL, SIGUSR1, SIGURG,
            SIGSEGV, SIGABRT, SIGINT, SIGSTKFLT, SIGTTIN, SIGFPE, SIGSTOP, SIGALRM).tap( { &deinit-term(%signals{$_}); } );

    unless $is-a-terminal {
        return;
    }
    my Int:D ($cols, $rows, $xpixels, $ypixels, @rest) = GetTerminalSize();
	say("");                                         # ensure we have space for the scrollbar       #
    say "" if $BARS == Bars::Two;                    # extra row for the second progress-bar        #
	printf("%s%d", "\e", 7);                         # save the cursor location                     #
	printf("%s%d;%dr", "\e[", 0, $rows - $bars);     # set the scrollable region (margin)           #
	printf("%s%d", "\e", 8);                         # restore the cursor location                  #
	printf("%s%dA", "\e[", 1);                       # move cursor up                               #
	printf("%s%dA", "\e[", 1) if $BARS == Bars::Two; # move cursor up                               #
}

sub deinit-term(Int:D $sig) is export {
    my &stack = sub ( --> Nil) {
        while @signal {
            my &elt = @signal.pop;
            &elt();
        }
    };
    my %signals = Signal.kv;
    if $sig == %signals«SIGVTALRM» || $sig == %signals«SIGCHLD»  || $sig == %signals«SIGCONT» || $sig == %signals«SIGPIPE» || $sig == %signals«SIGXCPU» {
        return;
    }
    if $is-a-terminal {
        my Int:D ($cols, $rows, $xpixels, $ypixels, @rest) = GetTerminalSize();
        printf("\e7");                                   # save the cursor location                     #
        printf("%s%d;%dr", "\e[", 0, $rows);             # reset the scrollable region (margin)         #
        printf("%s%d;%dH", "\e[", $rows, 0);             # move cursor to the bottom line               #
        printf("%s0K", "\e[");                           # clear the line                               #
        if $BARS == Bars::Two {
            printf("%s%d;%dH", "\e[", $rows - 1, 0);     # move cursor to the second from bottom line   #
            printf("%s0K", "\e[");                       # clear the line                               #
        }
        printf("%s%d", "\e", 8);                         # reset the cursor location                    #
    }
    given $sig {
        when %signals«SIGHUP» {    #  1 #
            $*ERR.printf("sighup caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGINT» {    #  2#
            $*ERR.say("   keyboard interrupt caught.");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGQUIT» {   #  3 #
            $*ERR.printf("sigquit caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGILL» {    #  4 #
            $*ERR.printf("sigill caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGTRAP» {   #  5 #
            $*ERR.printf("sigtrap caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGABRT» {   #  6 #
            $*ERR.printf("sigabrt caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGFPE» {    #  8 #
            $*ERR.printf("sigfpe caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGKILL» {   #  9 #
            $*ERR.printf("sigkill caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGBUS» {    # 10 #
            $*ERR.printf("sigbus caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGSEGV» {   # 11 #
            $*ERR.printf("sigsegv caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGSYS» {    # 12 #
            $*ERR.printf("sigsys caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGPIPE» {   # 13 #
            $*ERR.printf("sigpipe caught.\n");
            &stack();
            return;
        }
        when %signals«SIGALRM» {   # 14 #
            $*ERR.printf("sigalrm caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGTERM» {   # 15 #
            $*ERR.printf("sigterm caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGURG» {    # 16 #
            $*ERR.printf("sigurg caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGSTOP» {   # 17 #
            $*ERR.printf("sigstop caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGTSTP» {   # 18 #
            $*ERR.printf("sigtstp caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGCONT» {   # 19 #
            $*ERR.printf("sigcont caught.\n");
            &stack();
            return;
        }
        when %signals«SIGCHLD» {   # 20 #
            $*ERR.printf("sigchld caught.\n");
            &stack();
            return;
        }
        when %signals«SIGTTIN» {   # 21 #
            $*ERR.printf("sigttin caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGTTOU» {   # 22 #
            $*ERR.printf("sigttou caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGXCPU» {   # 24 #
            $*ERR.printf("sigxcpu caught.\n");
            return;
        }
        when %signals«SIGXFSZ» {   # 25 #
            $*ERR.printf("sigxfsz caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGVTALRM» { # 26 #
            $*ERR.printf("sigvtalrm caught.\n");
            return;
        }
        when %signals«SIGPROF» {   # 27 #
            $*ERR.printf("sigprof caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGUSR1» {   # 30 #
            $*ERR.printf("sigusr1 caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGUSR2» {   # 31 #
            $*ERR.printf("sigusr2 caught.\n");
            &stack();
            exit(-$sig.Int);
        }
        when %signals«SIGPOLL» {
            #$*ERR.printf("sigpoll caught.\n");
            return;
        }
        default {
            return;
        }
    }
}
