# Contributing to the project

At the moment, the biggest contributions are: use the tool, [perform the experiment]
and [publicizing it](https://github.com/abntex/limarka/wiki/Imprensa).

[perform the experiment]: https://github.com/abntex/limarka/wiki/Experimentos

Pull requests are always welcome. By participating in this project you are According to the [code of conduct].

The project originates from a scientific research (in progress) on the use of markup language for the preparation of monographs (translation note: it's like a dissertation but at graduation).

- [Perform the experiment of use](https://github.com/abntex/limarka/wiki/Experimentos)

Access the [chat in gitter](http://gitter.im/abntex/limarka) and talk to us, regardless of your profile.

# Teacher

As a teacher you can contribute with limarka by publicizing it and offering limarka as an option for your students to perform assignments.

- When requesting activity reports to students, suggest using limarka. Although limarka is meant to produce dissertation and theses, it can be easily used for reporting purposes.

- Suggest your students to try limarka. Limarka is free and can be used on Linux, OS X and Windows. We do not recommend using limarka in works that require a lot of formulas, theorems or proofs. Latex writings tools offer better support for this.

- Update your personal / institutional page by adding a [link to limarka](https://github.com/abntex/limarka/wiki/Imprensa). Your students and others will know the tool in this way.

- Request to include limarka as an alternative in the materials of instructions of writing academic works, or in the disciplines of Methodology. The ideal time to introduce students to the tool is in Methodology classes. For now the focus of the tool are dissertation and theses, but soon will also be possible to writer articles as well.

- Disseminate news about limarka in the mail-lists of teachers or students. The target audience of the tool are the students, these lists provide ways to find them.

- Recommend to publish a post about limarka in the news agency of your institution. The news agencies of the institutions are a great medium for disclosure, check how to contact the agency and recommend a story to be published.

- Click the star [in the project repository](https://github.com/abntex/limarka) (equivalent to a *like*) in github.

# Student

- Use limarka for reporting
- Participate in the [tool-use experiment](https://github.com/abntex/limarka/wiki/Experimentos) - URGENTLY NEEDED!
- Share some limarka news on your social networks or mail-list of students or laboratories
- Write your conclusion paper or your proposal / project with limarka and share your experience
- Click on the star [in the project repository] (https://github.com/abntex/limarka) (equivalent to a *like*) in github.

# Latex User

We would like to convert [known abnTeX2 customizations](https://github.com/abntex/abntex2/wiki/CustomizacoesConhecidas) for use with limarka.

# Ruby Developer

Do you want to participate in the development of limarka? Consider the [issues marked with label help needed](https://github.com/abntex/limarka/labels/help%20wanted) as an invitation to contribute with us.

Fixing bugs and implementing new features through Pull requests are always welcome.

By participating in this project you agree to the [code of conduct].

[code of conduct]: https://github.com/abntex/limarka/blob/master/CODE_OF_CONDUCT.md

# Web developer

We wish to improve the experience of using the tool by implementing A site that generates dynamic content.

Suppose a user wants to add a reference to an article, I'd like That when user click on "Article" a form will be presented for fill and match the bib fields of this type of entry. When the user will filling the form the bib code is generated automatically for insertion into the file of references.

To understand the functionality see the site [http://shields.io](http://shields.io/) and click on any of the badges.

## Implementing new functionality

[Create a issue](https://github.com/abntex/limarka/issues/new) describing the new functionality.

Perform a fork on the project, then clone your fork:

    git clone git@github.com:your-username/limarka.git

Configure your machine:

    ./bin/setup

Make sure the tests are going:

    rake

Create a branch from the master for its functionality:

    git checkout -b my-functionality

Make the changes. Add tests (optional, but desired) for your changes. Have the tests pass:

    rake
    git add file-modified1 file-modified2
    git commit
    
If there is an Issue for the implemented functionality [use the issue number in the commit message](https://help.github.com/articles/closing-issues-via-commit-messages/) to maintain traceability.

Make a Push for your fork:

    git push origin my-functionality

[Submit a pull request](https://github.com/abntex/limarka/compare/). Change the issue / PR title to the text you want to add to [CHANGELOG](https://github.com/abntex/limarka/blob/master/CHANGELOG.md)

## Development

You may wish to consult the [tool development page](https://github.com/abntex/limarka/wiki/Desenvolvimento).

# Participating in the forum

You can also join the [limarka discussion forum](https://groups.google.com/forum/#!forum/limarka).
