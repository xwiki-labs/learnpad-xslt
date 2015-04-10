This is a temporary repo.  It should be integrated into the LearnPAd platform
(xwiki-labs/learnpad) in the end.

## Introduction
The purpose is to import Adoxx files (modeling tool) into a wiki.  The models
are Business Process models.  They are converted into a "XWikish structure" (see
below) and then import in the XWiki with the help of a REST service.

## XWikish structure
XWiki is based on spaces, pages and objects.  For the purpose of this import, a
structure as been designed.

```
ROOT
└── space1
    ├── pagename1
    │   ├── index.xml
    │   └── objects
    │       ├── classspacename1
    │       │   └── classname1
    │       │       ├── file0.xml
    │       │       ├── file1.xml
    │       │       ├── file2.xml
    │       │       └── file3.xml
    │       └── classspacename2
    │           └── classname2
    │               └── file.xml
    └── pagename2
        └── index.xml
```

The XML file are written with the format use in the REST API of XWiki.

## `xwiki-transformer`

The transformer will take a adoxx file (XML file of the models) and a stylesheet
file (`addoxx2xwiki.xsl`) to produce a "XWikish structure".  This Java program
take these 2 files as arguments.

## `xwiki-importer`

The importer is a REST component in XWiki.  You may want to install and deploy a
XWiki instance before using it.  Moreover, since the operation will create
different kind of objects (like `LearnPAdCode.FlowNodeClass` or
`LearnPAdCode.LinkClass`), you may want to import in your wiki the XAR that
you can build from
[here](https://github.com/xwiki-labs/learnpad/tree/master/lp-collaborative-workspace/lp-cw-component/lp-cw-component-application).

Once you've done, put the JARs of this `xwiki-importer` inside your instance and
you should be fine.

To use this REST service, this is the kind of `curl` command you should use.

```
curl --verbose --user Admin:admin --request PUT "http://localhost:8080/xwiki/rest/learnpad/wiki?path=/path/to/ROOT"
```
