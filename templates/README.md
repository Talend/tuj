# Test Unit Job description

TUJ is a Talend job that test one facet of one component. It is the unit test for Talend components. TUJs are executed on TTP (Talend Test Platform). There are several TTP environments to test components/studio within different versions of java. Currently we have some: https://tuj.talend.com/ (only 1.7 and 1.8 Oracle are maintened). A new one is available for components developpers.


## What is it made of ?
A TUJ is mainly composed of 4 parts:
1. Loading context
1. Execution of the component
1. Check the execution with some tests
1. Some cleaning if needed

### Loading context
The tuj-runner gives four context parameters to the job:
1. `param_file_path` : Contains the path to a context file to load
1. `result_table` : This is the table used by the job to store the result of its tests
1. `data_dir` : The folder of the job where it can load some resources. It can also contain a context.csv file to load specific non-credentials context 
1. `data_output_dir` : The folder where the job can store generated files

The main context file to load from `param_file_path`, is `template.csv` file from tuj-config repository. This file contains all TUJs credentials : https://github.com/Talend/tuj-config/blob/tal-rd01/tuj-runner/conf/template.csv

The `tuj-config` repository is a private one. Only critical context variables must be added into `template.csv`, mostly credentials. This file is loaded within the tPreJob.

For other context variables, you can add them into a `context.csv` file into the root folder of your TUJ. It will be loaded too if it exists. Those local context files are created along within the TUJ.

![Loading context within the job](./images/template_load_context.png)

The template context loading is :
1. First it loads the `template.csv` file
1. Then it updates the `data_dir` context variable to set the root of the job
1. Finally, if the local `context.csv` file exists, it is loaded too

![To remember](./images/warning.png)
- Critical context keys : into `template.csv` from tuj-config private repository
- Other context : into context.csv in the root folder of the TUJ

### Execution of the component

Once the context is loaded, you have to create a job to test the facet you want of the component. Currently, test environments are shared between all TUJs. So to avoid conflicts, use the available `pid` String variable to identify what you generate. For example, the name of a user you add into a database should be `"name_"+pid`, or the name of a table `"TUJ_TDI12345_mytable_"+pid` and so on...

If it is possible, create a job with only one instance of the component you want to test. Create as many TUJs as you have configuration to test.

Your execution should generate some data to be tested in the next section.

![Execution of the main component](./images/template_exec_compo.png)

The template tests the `tFileTouch` component. You have to remove this component to create your own use case.

![To remember](./images/warning.png)
- Use only one instance of the component you want to test if possible
- Use `pid` variable (several instances of the TUJ can be runned in the same time)
- One TUJ test only one configuration of the main component

### Check the execution with some tests
Once your component has been executed and has generated some data, you have to use tAssert components to validate it. `tAssert` components will be caught by the `tAssertCatcher` which is provided into the template. So, all tests of the TUJ will be registered into the TTP Mysql database. You can have several tAssert in the same TUJ, but it's better to have only one.

![Check the execution of your use case](./images/template_assert.png)
The template provides an example of assertion to check if the tfileTouch has well created the file. The sub-job `Register the TUJ assertions into Colibri` should not be edited. You can deactivate `colibri / tMysqlOutput` component while you are creating the job.

![To remember](./images/warning.png)
- Use `tAssert` to test generated data
- All tests are registered into the mysql database of TTP

### Some cleaning if needed
If you have some cleaning to do, like remove inserted tuple from the database or delete a generated file, you can do it within the tPostJob section.

![Cleaning](./images/template_clean.png)

The template, as cleaning example, delete the file created by the `tFileTouch`. 

![To remember](./images/warning.png)
- Post job section is dedicated to cleaning

## How to design my own TUJ ?
To help you to design TUJs, a template has been created.

### Import the template into your studio
At the same level of this `README.md`, you will find the template for TUJ in standard folder. So:
- From your studio, execute `Import items` and select `standard` folder
- Check `standard_tuj_template` and import it
- _**Duplicate it**_ to create your own TUJ, so that you can keep the template unchanged and _there will be no conflicts with internal id_.

![Duplicate the template](./images/template_duplicate.png)
- Select a name based on this pattern : `(JIRA_ID)_(component_name)_(use_case)`, examples:
    - TDI34567_scd_null_values
    - TDI39306_WebApp_Authentication
    
![To remember](./images/warning.png) 
Note that green subjobs should not been modified 

### how to run the template
The template is a runnable TUJ. If you try to run it, it will fail since:
- The global context file defined by `param_file_path` doesn't exist in your local environment
- Neither the local context file defined by `context.getProperty("data_dir")+"/context.csv"`

You can create them. The first one must contain all context variable except `filename` which is into the local one.

Then configure your TUJ context `param_file_path` with the path to your gobal context file, and copy your local context file into the folder `data_dir + job_name`.

Then, you can  deactivate the `Colibri(tMysqlOutput_1)` component and execute the TUJ.

### How to personalize
To personalize your TUJ:
1. Delete the `Main sub-job` component and create your own sub-job/use case to test your component and generate files to test
1. Delete the `Unit tests sub-job` and add your own assertions
1. Delete the `tFileDelete` component and create your own cleaning section

![To remember](./images/warning.png) 
Note that green subjobs should not been modified

## Talend Test Platform for developers

### Execute your TUJ within Jenkins
The Jenkins of TTP for developers is available on https://tal-rd209.talend.lan/jenkins/ : 

1. Select the `launch-tuj` job and then `Build with parameters`
1. Full fill properties:
    1. TALEND_GIT_BRANCH: the branch use to build the studio which execute the TUJs.
       Usually, let `origin/master` since you want to test your development on the latest studio version.
    1. TALEND_REPO: the jenkins tuj repository (_let default value `tuj`_).
    1. JVM_PATH: The path to the TTP jvm  (_let default value `/usr/java/default/bin/java`_).
    1. TALEND_PARTIAL_GIT_BRANCH: the branch that will be checkouted in `TALEND_REPO` (_if not empty_). This branch should contain the TUJs you want to test.
       This is the branch name where your development has been done. The same branch name should be used in all impacted repositories. So, if you have created a new TUJ to test your development, you must have a branch with this given name in `tuj` repository.
    1. JOBS_FILTER: Filter jobs to run by families
        1. Families are folders where are stored TUJs : https://github.com/Talend/tuj/tree/master/tuj/java
1. Click on `build` button

**More explanations about `TALEND_PARTIAL_GIT_BRANCH`:**
*The TTP plateform will try to checkout TALEND_PARTIAL_GIT_BRANCH on all repositories (tuj, tdi-studio-se, tcommon-studio-se, etc...). It will not fail if it doesn't exist. So, if you have a fix on `tdi-studio-se` repo on a branch `someone/TDI-xxx_my_fix`, set `TALEND_PARTIAL_GIT_BRANCH=someone/TDI-xxx_my_fix`. Then TTP will first checkout master on all repositories, then try to checkout `someone/TDI-xxx_my_fix` on all repositories too. This second checkout will succeed on `tdi-studio-se`. So `tuj` repo will stay on master, and the studio will be built with your fix. So, existing TUJ will test your new fix. If you have created a new TUJ to test your development, create a branch named `someone/TDI-xxx_my_fix` in `tuj` repository, and it will be checkouted and then executed.*


![To remember](./images/Jenkins_conf.png) 

### Check execution on Colibri
Once the talend job is terminated, you can access its result into Colibri: https://192.168.11.145/colibri/overview.php

1. Go into `jobs` menu
1. Select the desired studio version in `branch` drop-down list (_in the top/right of the page_)
1. If your TUJ is a new one, it is in draft mode (_it has not been validated yet_), and you won't be able to see it. You have to complete the url with `?mode=draft` and reload the page
    1. Draft jobs are not taken into account in TTP statistics
1. Configure the main form:
    1. last execution: set `1` if your execution is the last one
    1. Check `Smart display` to hide successful TUJs and focuses on errors
    
![Colibri form](./images/colibri.png) 
