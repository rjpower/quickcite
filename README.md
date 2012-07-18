QuickCite
=========

Simplify your (academic) life.  Instead of manually hunting down references, let QuickCite do the work for you!

Quickstart
----------

### Installation:

    gem install quickcite

### Usage

Add it to your Makefile:

    paper.pdf: ...
      quickcite -b paper.bib *.tex
      ...

Now add a reference in your paper:

> I really liked this paper: \cite{PowerPiccolo}
>
> But of course, this one was even better: \cite{Mapreduce}


That's it!  Any missing references will be queried on DBLP, and you can accept
the paper you intended:

    Missing reference for PowerPiccolo
    Result to use for {PowerPiccolo}:
      (0) Skip this citation
      (1) A novel fuzzy system for wind turbines reactive power control.
          Geev Mokryani, Pierluigi Siano, Antonio Piccolo, Vito Calderaro, Carlo Cecati
      (2) Piccolo: Building Fast, Distributed Programs with Partitioned Tables.
          Russell Power, Jinyang Li
      (3) Impact of Chosen Error Criteria in RSS-based Localization: Power vs Distance vs Relative Distance Error Minimization.
          Giuseppe Bianchi, Nicola Blefari-Melazzi, Francesca Lo Piccolo

Questions or suggestions: power@cs.nyu.edu.
