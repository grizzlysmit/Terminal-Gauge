Terminal::Gauge
===============

Table of Contents
-----------------

  * [NAME](#name)

  * [AUTHOR](#author)

  * [VERSION](#version)

  * [TITLE](#title)

  * [SUBTITLE](#subtitle)

  * [COPYRIGHT](#copyright)

    * [sub backup-device-val(--> Str) is export](#sub-backup-device-val---str-is-export)

  * [Introduction](#introduction)

    * [Example](#example)

NAME
====

Terminal::Gauge

AUTHOR
======

Francis Grizzly Smit (grizzly@smit.id.au)

VERSION
=======

0.1.0

TITLE
=====

Terminal::Gauge.rakumod

SUBTITLE
========

A **Raku** module that supports ANSI colour terminal progress gauges.

COPYRIGHT
=========

LGPL V3.0+ [LICENSE](https://github.com/grizzlysmit/GUI-Editors/blob/main/LICENSE)

[Top of Document](#table-of-contents)

Introduction
============

A **Raku** module that supports ANSI colour terminal progress gauges. This module utilises ANSI escape sequences to colour and manipulate the output it reserves either the bottom row of the terminal `init-term()` (or `init-term(Bars::One)`) or it will reserve the bottom 2 rows `init-term(Bars::Two)` for the gauge or gauges then calls to `progress-bar(Str:D $prfix, Int:D $current, Int:D $length --> Bool)` and in the case of `init-term(Bars::Two)` `sub-progress-bar(...)` will update the progress bars, `progress-bar(Str:D $prfix, Int:D $current, Int:D $length --> Bool)` will put it's gauge on the bottom line and `sub-progress-bar(Str:D $prfix, Int:D $current, Int:D $length --> Bool)` writes to the line above in the `init-term(Bars::Two)` case, finally the `deinit-term(Int:D $sig)` function removes the progress bars and makes the bottom lines part of the normal scrollable region of the terminal again.

Example
-------

```raku
Example inspired by App::Backup which uses
Terminal::Gauge

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
    my Str $current-host;
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
            next;
        } elsif ! shell("ping -c 1 $host.local > /dev/null 2>&1 ") {
            say "$host.local does not exist  or is down";
            say "$thishost.local <---> $host.local: skipped";
            next;
        } else {
            $current-host = $host;
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
        } # end of if else chain #
        sub-progress-bar("$current-host: ", get-sub-length()); # show 100% #
    } # for @hosts -> $host #
    progress-bar(" Total: ", get-length(), get-length()); # show full 100% #
    sleep(5); # optional but help the user to see that it  is complete #
    signal().tap({ exit $_ });
}
```

