
% Author: Kartik_V_Deshpande
% Supervisors: Dheeraj_Kumar
% Electronics_and_Communication, IIT_Roorkee, INDIA
% Deshpande, K. V., & Kumar, D. (2024). Time and memory scalable algorithms for clustering tendency assessment of big data. Information Sciences, 664(120324), 120324. doi:10.1016/j.ins.2024.120324


function RiV_without_dist_matrix=MST_iVAT(cut_kdt) % cut_kdt = MST edges

n=length(cut_kdt); cut_idxx=zeros(n,1); i=1;
RiV_without_dist_matrix_idx=zeros(n,5);
RiV_without_dist_matrix_idx_idx=1;

cut_kdt_for_partition=cut_kdt(2:end);

partition_start_end=zeros(n,4)+NaN;
partition_start_end_push_idx=1;
partition_start_end_pop_idx=1;

[max_cut_kdt,max_cut_kdt_idx]=max(cut_kdt_for_partition);
longest_edge_length=max_cut_kdt;
cut_idxx(i)=max_cut_kdt_idx;

partition_1=1:max_cut_kdt_idx;
partition_1_cut=1:max_cut_kdt_idx-1; 
partition_2=max_cut_kdt_idx+1:n;
partition_2_cut=max_cut_kdt_idx+1:n-1;

if(length(partition_1)>1)
    partition_start_end(partition_start_end_push_idx,:)=[partition_1(1) partition_1(end) partition_1_cut(1) partition_1_cut(end)];
    partition_start_end_push_idx=partition_start_end_push_idx+1;
end

if(length(partition_2)>1)
    partition_start_end(partition_start_end_push_idx,:)=[partition_2(1) partition_2(end) partition_2_cut(1) partition_2_cut(end)];
    partition_start_end_push_idx=partition_start_end_push_idx+1;
end

RiV_without_dist_matrix_idx(RiV_without_dist_matrix_idx_idx,:)=[partition_1(1) partition_2(1) partition_1(end) partition_2(end) 1];
RiV_without_dist_matrix_idx_idx=RiV_without_dist_matrix_idx_idx+1;

while partition_start_end_push_idx>partition_start_end_pop_idx
    
    this_partition=partition_start_end(partition_start_end_pop_idx,1):partition_start_end(partition_start_end_pop_idx,2);
    this_partition_cut=partition_start_end(partition_start_end_pop_idx,3):partition_start_end(partition_start_end_pop_idx,4);
    partition_start_end_pop_idx=partition_start_end_pop_idx+1;
    
    [max_cut_kdt,max_cut_kdt_idx]=max(cut_kdt_for_partition(this_partition_cut));
    i=i+1;
    cut_idxx(i)=this_partition_cut(max_cut_kdt_idx);
    
    partition_1=this_partition(1:max_cut_kdt_idx);
    partition_1_cut=this_partition_cut(1:max_cut_kdt_idx-1);
    partition_2=this_partition(max_cut_kdt_idx+1:end);
    partition_2_cut=this_partition_cut(max_cut_kdt_idx+1:end);
    
    if(length(partition_1)>1)
        partition_start_end(partition_start_end_push_idx,:)=[partition_1(1) partition_1(end) partition_1_cut(1) partition_1_cut(end)];
        partition_start_end_push_idx=partition_start_end_push_idx+1;
    end
    if(length(partition_2)>1)
        partition_start_end(partition_start_end_push_idx,:)=[partition_2(1) partition_2(end) partition_2_cut(1) partition_2_cut(end)];
        partition_start_end_push_idx=partition_start_end_push_idx+1;
    end
    
    RiV_without_dist_matrix_idx(RiV_without_dist_matrix_idx_idx,:)=[partition_1(1) partition_2(1) partition_1(end) partition_2(end) max_cut_kdt/longest_edge_length];
    RiV_without_dist_matrix_idx_idx=RiV_without_dist_matrix_idx_idx+1;
    
end
RiV_without_dist_matrix_idx(RiV_without_dist_matrix_idx_idx,:)=[];

RiV_size=n;
scaling_factor=1;
is_memory_not_enough=1;
while(is_memory_not_enough)
    try
        RiV_without_dist_matrix=zeros(RiV_size);
        is_memory_not_enough=0;
    catch ME
        ME.message
        RiV_size=ceil(RiV_size/2);
        scaling_factor=scaling_factor*2;
    end
end

RiV_without_dist_matrix_idx(:,1:4)=ceil(RiV_without_dist_matrix_idx(:,1:4)/scaling_factor);

[len,~]=size(RiV_without_dist_matrix_idx);
for i=1:len
    RiV_without_dist_matrix(RiV_without_dist_matrix_idx(i,1):RiV_without_dist_matrix_idx(i,3),RiV_without_dist_matrix_idx(i,2):RiV_without_dist_matrix_idx(i,4))=RiV_without_dist_matrix_idx(i,5);
    RiV_without_dist_matrix(RiV_without_dist_matrix_idx(i,2):RiV_without_dist_matrix_idx(i,4),RiV_without_dist_matrix_idx(i,1):RiV_without_dist_matrix_idx(i,3))=RiV_without_dist_matrix_idx(i,5);
end

