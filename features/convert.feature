@slow
Feature: Convert files to platform target formats

  Background:
    Given prerequisites have been fetched

  Scenario: Convert files
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "build/export/kindle/the-foo-book.html" with:
    """
    <html>
      <head><title>The Foo Book</title></head>
      <body>
        <h1>Chapter 1</h1>
        <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</p>
      </body>
    </html>
    """
    And a file named "build/export/epub/the-foo-book.html" with:
    """
    <html>
      <head><title>The Foo Book</title></head>
      <body>
        <h1>Chapter 1</h1>
        <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</p>
      </body>
    </html>
    """
    And a file named "build/export/pdf/the-foo-book.tex" with:
    """
    \documentclass{report}
    \input{headers}

    \title{The Foo Book}
    \author{Avdi Grimm}
    \date{11 July 2011}

    \begin{document}

    \setcounter{tocdepth}{5}

    \chapter{About}

    \label{sec-1}

    Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

    \begin{listing}[H]
    \caption{Hello world in Ruby}
    \begin{minted}[linenos=true,fontsize=\small,framesep=1ex,frame=single,stepnumber=5]{ruby}
    puts "hello, world"
    \end{minted}
    \end{listing}

    \end{document}
    """
    When I run `orgpress convert`
    Then the exit status should be 0
    Then a file named "build/convert/kindle/the-foo-book.mobi" should exist
    And a file named "build/convert/epub/the-foo-book.epub" should exist
    And a file named "build/convert/pdf/the-foo-book.pdf" should exist
    When I unpack "build/convert/epub/the-foo-book.epub" into "unpack"
    Then a file named "unpack/the-foo-book.html" should exist
    
