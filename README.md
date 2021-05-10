# Data validation report built with shiny.fluent components

This repo contains a Shiny app code which is a proof of concept of a data validation report
generated from [data.validator](https://github.com/Appsilon/data.validator) package. At the same
time it is a test run for our [shiny.fluent](https://github.com/Appsilon/shiny.fluent) package,
which allows building Shiny apps with React.js components, without need for JS programming.

You can view the application here: https://pawelp.shinyapps.io/data-validator-report

![Data validation report](./images/app-recording.gif)

## Story behind the app

In our projects we perform data validation before we use it, especially when the data
is updated periodically or it can be uploaded by the user. Data almost always contains some errors.
Most of them are related to the format, but often there are also quantitative requirements. But that's
not all - there are also very important expert rules which are project specific. You can
read about them in our [blogpost about data quality](https://appsilon.com/data-quality/)
and how we saved real money with them.

<p align="center">
<img src="./images/data-quality-iceberg.png" alt="Data Quality Levels" width="400"/>
</p>

Important part of our validation is close collaboration with the client and project stakeholders.
There are often situations that the validation rule depends on the expert knowledge or business decision.
To make this collaboration efficient, we present validation results as a report and share with the client.
Thanks to the report it is easier to inspect corrupted data and discuss potential root cause and solution.

I used [shiny.fluent](https://github.com/Appsilon/shiny.fluent) package to build a proof of concept that:

* proves how easy it is to use React.js components within Shiny
* has business looking UI thanks to the [Microsoft Fluent UI](https://developer.microsoft.com/en-us/fluentui) components

**Note:** this POC app is a hypothetical report generated after running [data_validation.R](./data_validation.R) code.

## About data.validator

Data.validator is like *testthat*, but designed for data validation.
It is built on top of awesome [assertr](https://github.com/ropensci/assertr) package,
with simplified API for generating reports. Most common use case is to combine data.validator code
with data processing scripts used in ETLs / pipelines / batch jobs.

See [the repo](https://github.com/Appsilon/data.validator) for more examples.

**Note:** Current version released on CRAN (0.1.5) generates rmarkdown HTML report using shiny.semantic.
This POC shiny.fluent app is not integrated yet.

## About shiny.fluent

At the first look it might seem like another package with regular HTML components themed with CSS and JS.
The difference is that it uses React.js components, which is a different approach. As a first library with
React.js components ported to Shiny we took [Microsoft Fluent UI](https://developer.microsoft.com/en-us/fluentui).

See [the repo](https://github.com/Appsilon/shiny.fluent) for example apps built with shiny.fluent.
