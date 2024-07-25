function [f,h,n_el,bin_x] = dot_plot(x,groups,bins,opts)
% [f,h,n_el,bin_x] = dot_plot(x,groups,bins,opts)
% Creates dot plot of data in x with each point colored based on the 
% element's group membership.
% Also has options for multiple plot markers.
% Can handle missing values.
%
% INPUTS
%   x: data vector, used to create dot plot
%   groups: numeric vector (same length as x) indicating which group each
%       element in x belongs to. Points will be colored based on group
%       membership.
%   bins: bin edges used to divide the data into bins
%   opts: optional plot arguments
%       .mkrs: string indicating the marker style of the points; must
%           either be length one (all points have the same style) or the
%           same length as x (indicating the marker style for each point)
%           (default: 's' = square).
%           Possible markers:
%                   markers o s d ^ V < > p h will be filled
%                   markers + * . x will have their their thickness controlled by the linewidth
%       .clrs: RGB triplets indicating the colors to plot points of each
%           group; number of rows must equal the numebr of groups (default:
%           lines(# groups) ).
%       .mkr_size: scalar controlling size of the markers OR vector
%           the size of each individual point; will need to be adjusted
%           based on your figure size and number of data points
%           (default depends on number of data points).
%       .lw: scalar controlling the linewidth of markers that are not
%           filled (default depends on number of data points).
%       .yticks: boolean indicating whether to put tick marks on the y-axis
%           (default: true)
%       .center_ticks: boolean indicating whether to put the x tick marks
%           on the center of each bins; otherwise, x tick marks will be on
%           the edges of each bin (default: false);
%   
% OUTPUTS
%   f: figure handle
%   h: plot handle (length = number of points)
%   n_el: number of elements in each bin
%   bin_x: center of each bin
%
% Gabrielle M. Schroeder
% Newcastle University School of Computing
% 21 January 2019

% set defaults
if nargin<4
    opts=struct();
end

if ~isfield(opts,'yticks'); opts.yticks=true; end
if ~isfield(opts,'center_ticks'); opts.center_ticks = false; end

% number of values to plot
n = length(x);

% make sure other vectors are the correct length
if length(groups) ~= n
    error('The clr_groups vector must be the same length as x');
end

if ~isfield(opts,'mkrs')
    opts.mkrs = repmat('s',1,n);
elseif length(opts.mkrs) == 1
    opts.mkrs = repmat(opts.mkrs,1,n);
elseif length(opts.mkrs) ~= n
    error('The mkrs string must be the same length as x');
end

if isfield(opts,'mkr_size')
    if length(opts.mkr_size) ~= n && length(opts.mkrs_size)~=1
        error('The mkr_size vector must be the same length as x or length 1');
    end
end

% default sizes for markers
if ~isfield(opts,'mkr_size')
    if n<10; opts.mkr_size = 5000; elseif n<50; opts.mkr_size = 2000; else; opts.mkr_size = 1000; end
end
if ~isfield(opts,'lw')
    if n<10; opts.lw = 10; elseif n<50; opts.lw = 5; else; opts.lw = 2; end
end

if length(opts.mkr_size) == 1
    opts.mkr_size = repmat(opts.mkr_size,1,n);
end

% remove any missing values
x_nan = isnan(x); 
if sum(x_nan) > 0
    disp(['Removing ' num2str(sum(x_nan)) ' missing values'])
    x = x(~x_nan);
    groups = groups(~x_nan);
    opts.mkrs = opts.mkrs(~x_nan);
    opts.mkr_size = opts.mkr_size(~x_nan);
end

% check that all of the elements of x are included in the bins
n_outside = sum(x<bins(1) | x>bins(end));
if n_outside > 0
    error([num2str(n_outside) ' elements of x are outside of the range of the given bin edges'])
end

% number of colour groups
group_numbers = unique(groups);
n_groups = length(group_numbers);

% colours to plot elements of each group
if ~isfield(opts,'clrs')
    opts.clrs = lines(n_groups);
elseif size(opts.clrs,1) ~= n_groups
    error(['The number of colours (opts.clrs) must match the number of groups in clr_groups (' num2str(n_groups) ')'])
end

% RGB vectors
clr_RGB = zeros(n,3);
for i=1:n_groups
    clr_RGB(groups == group_numbers(i),:) = repmat(opts.clrs(i,:),sum(groups == group_numbers(i)),1);
end

% number of bins
n_bins = length(bins) - 1;
n_el = zeros(1,n_bins);
bin_x = zeros(1,n_bins);

% plot
f=figure();
h=zeros(n,1);
h_count=1;
hold on
for i=1:n_bins
    % find elements in the bin
    if i<n_bins
        el_idx = find(x>=bins(i) & x< bins(i+1));
    elseif i==n_bins % last bin includes rightmost value (like histogram function)
        el_idx = find(x>=bins(i) & x<= bins(i+1));
    end
    
    % number of elements and their plot specifications
    n_el(i) = length(el_idx);
    el_clr = groups(el_idx);
    el_mkrs = opts.mkrs(el_idx);
    el_RGB = clr_RGB(el_idx,:);
    el_mkr_size = opts.mkr_size(el_idx);
    
    % sort elements by group
    [~,sort_idx] = sort(el_clr);
    elsort_mkrs = el_mkrs(sort_idx);
    elsort_RGB = el_RGB(sort_idx,:);
    elsort_mkr_size = el_mkr_size(sort_idx);
    
    % bin x coordinate
    bin_x(i) = mean([bins(i) bins(i+1)]);
    
    % plot
    el_count=1;
    for j=1:n_el(i)
        if contains('osd^V<>ph',elsort_mkrs(j))
            h(h_count) = scatter(bin_x(i),el_count,elsort_mkr_size(j),elsort_RGB(j,:),elsort_mkrs(j),'filled');
        else
            h(h_count) = scatter(bin_x(i),el_count,elsort_mkr_size(j),elsort_RGB(j,:),elsort_mkrs(j),'LineWidth',opts.lw);
        end
        el_count=el_count+1;
        h_count=h_count+1;
    end
    
end
hold off

axis([bins(1) bins(end) 0 max(n_el)+0.5])
if opts.center_ticks==true 
    set(gca,'XTick',bin_x,'YTick',0:2:max(n_el)); % mark center of bins
else 
    set(gca,'XTick',bins,'YTick',0:2:max(n_el));  % mark edges of bins
end

if opts.yticks == false
    set(gca,'YTick',[]')
end


