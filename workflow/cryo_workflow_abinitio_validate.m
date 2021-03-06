function cryo_workflow_abinitio_validate(workflow_fname)
% Validate that the workflow file has all the parameters required for
% abinitio reconstruction.
%
% Yoel Shkolnisky August 2015.

% Read workflow file
tree=xmltree(workflow_fname);
workflow=convert(tree);

% Validate struct

assertfield(workflow,'info','working_dir');
assertfield(workflow,'info','logfile');
assertfield(workflow,'preprocess','numgroups');
assertfield(workflow,'abinitio','nmeans');
assertfield(workflow,'abinitio','nnavg');
