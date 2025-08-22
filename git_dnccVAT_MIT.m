
% Author: Kartik_V_Deshpande
% Supervisors: Dheeraj_Kumar, Osmar_R_Zaiane
% Electronics_and_Communication, IIT_Roorkee, INDIA
% Computing Science, University_of_Alberta, CANADA 

clc, clear, close all;

tic

% Input data is SXYTHLEI: [ Serial_number , x-coordinate , y-corrdinate , THL-features , epoch , sensor-id ] 
var=load('SXYTHLEI_MIT.mat','-mat'); data_o = var.SXYTHLEI;
no_of_nodes=max(data_o(:,8)); total_t=max(data_o(:,7)); sz = total_t*no_of_nodes;

data_idx=data_o(:,1); data_x=data_o(:,2); data_y=data_o(:,3);
data_T=data_o(:,4); data_H=data_o(:,5); data_L=data_o(:,6);
data_t=data_o(:,7); data_node_id=data_o(:,8);

% THL scatter plot
figure(1); s=scatter3(data_T, data_H, data_L,'.'); axis square, xlabel('Temperature');ylabel('Humidity');zlabel('Light');

data_node_id_t_index=zeros(total_t,no_of_nodes)+NaN;
for i=1:length(data_idx)
    data_node_id_t_index(data_t(i),data_node_id(i))=data_idx(i);
end

node_x_y=zeros(no_of_nodes,2);
for i=1:no_of_nodes
    idx=find(data_node_id==i,1);
    node_x_y(i,1)=data_x(idx);
    node_x_y(i,2)=data_y(idx);
end

nodes_dist_matrix=distance2(node_x_y,node_x_y);

K=6; % K is the number of nearest sensors to consider
nearest_K_nodes=zeros(no_of_nodes,K);
for i=1:no_of_nodes
    distance_from_this_node=nodes_dist_matrix(i,:);
    [val,idx]=sort(distance_from_this_node);
    nearest_K_nodes(i,:)=idx(2:K+1);
end

THL_dist_matrix_nearest_K=zeros(total_t*no_of_nodes,K*3+2)+NaN;
THL_nn_idx_nearest_K=zeros(total_t*no_of_nodes,K*3+2)+NaN;
for i=1:length(data_idx) % Forming all potential edges in this loop

    this_node=data_node_id(i);
    this_t=data_t(i);

    this_node_t_THL=[data_T(i) data_H(i) data_L(i)];

    this_node_nearest_K_nodes=nearest_K_nodes(this_node,:);

    if(this_t==1)
        this_node_nearest_K_nodes_t_idx=zeros(2*K+1,1);
        for k=1:K
            this_node_nearest_K_nodes_t_idx(k)=data_node_id_t_index(this_t,this_node_nearest_K_nodes(k));
        end
        for k=K+1:2*K
            this_node_nearest_K_nodes_t_idx(k)=data_node_id_t_index(this_t+1,this_node_nearest_K_nodes(k-K));
        end
        this_node_nearest_K_nodes_t_idx(2*K+1)=data_node_id_t_index(this_t+1,this_node);

        this_node_nearest_K_nodes_t_THL=[data_T(this_node_nearest_K_nodes_t_idx) data_H(this_node_nearest_K_nodes_t_idx) data_L(this_node_nearest_K_nodes_t_idx)];
        THL_dist_matrix=distance2(this_node_t_THL,this_node_nearest_K_nodes_t_THL);
        [val,idx]=sort(THL_dist_matrix);

        THL_nn_idx_nearest_K(i,1:length(this_node_nearest_K_nodes_t_idx))=this_node_nearest_K_nodes_t_idx(idx);
        THL_dist_matrix_nearest_K(i,1:length(this_node_nearest_K_nodes_t_idx))=val;

    else
        if(this_t<total_t)
            this_node_nearest_K_nodes_t_idx=zeros(3*K+2,1);
            for k=1:K
                this_node_nearest_K_nodes_t_idx(k)=data_node_id_t_index(this_t-1,this_node_nearest_K_nodes(k));
            end
            for k=K+1:2*K
                this_node_nearest_K_nodes_t_idx(k)=data_node_id_t_index(this_t,this_node_nearest_K_nodes(k-K));
            end
            for k=2*K+1:3*K
                this_node_nearest_K_nodes_t_idx(k)=data_node_id_t_index(this_t+1,this_node_nearest_K_nodes(k-2*K));
            end
            this_node_nearest_K_nodes_t_idx(3*K+1)=data_node_id_t_index(this_t-1,this_node);
            this_node_nearest_K_nodes_t_idx(3*K+2)=data_node_id_t_index(this_t+1,this_node);

            this_node_nearest_K_nodes_t_THL=[data_T(this_node_nearest_K_nodes_t_idx) data_H(this_node_nearest_K_nodes_t_idx) data_L(this_node_nearest_K_nodes_t_idx)];
            THL_dist_matrix=distance2(this_node_t_THL,this_node_nearest_K_nodes_t_THL);
            [val,idx]=sort(THL_dist_matrix);

            THL_nn_idx_nearest_K(i,1:length(this_node_nearest_K_nodes_t_idx))=this_node_nearest_K_nodes_t_idx(idx);
            THL_dist_matrix_nearest_K(i,1:length(this_node_nearest_K_nodes_t_idx))=val;

        else
            this_node_nearest_K_nodes_t_idx=zeros(2*K+1,1);
            for k=1:K
                this_node_nearest_K_nodes_t_idx(k)=data_node_id_t_index(this_t-1,this_node_nearest_K_nodes(k));
            end
            for k=K+1:2*K
                this_node_nearest_K_nodes_t_idx(k)=data_node_id_t_index(this_t,this_node_nearest_K_nodes(k-K));
            end
            this_node_nearest_K_nodes_t_idx(2*K+1)=data_node_id_t_index(this_t-1,this_node);

            this_node_nearest_K_nodes_t_THL=[data_T(this_node_nearest_K_nodes_t_idx) data_H(this_node_nearest_K_nodes_t_idx) data_L(this_node_nearest_K_nodes_t_idx)];
            THL_dist_matrix=distance2(this_node_t_THL,this_node_nearest_K_nodes_t_THL);
            [val,idx]=sort(THL_dist_matrix);

            THL_nn_idx_nearest_K(i,1:length(this_node_nearest_K_nodes_t_idx))=this_node_nearest_K_nodes_t_idx(idx);
            THL_dist_matrix_nearest_K(i,1:length(this_node_nearest_K_nodes_t_idx))=val;
        end
    end
end

Nds=data_node_id_t_index'; Nds=Nds(:); % Data points are considered based on epochs

I_nn_VAT=zeros(length(data_idx),3)+NaN; % I_nn_VAT = [ starting_point , end_point , MST_edge/cut ]; MST_edge/cut = used for MST-iVAT image;
THL_nn_idx=zeros(length(data_idx),1)+1;
% figure(3), s=scatter3(data_x,data_y,data_t,60,'.b'); s.SizeData = 100; hold on;   
k=0;
for i=1:length(data_idx) % This loop is meant for MST edge formations and select 5 to 10 epochs to view MST edges formation clearly
    temp=find(I_nn_VAT(:,1)==THL_nn_idx_nearest_K(Nds(i),THL_nn_idx(Nds(i))));
    if isempty(temp)
        k=k+1;
        I_nn_VAT(k,:)=[Nds(i), THL_nn_idx_nearest_K(Nds(i),THL_nn_idx(Nds(i))), THL_dist_matrix_nearest_K(Nds(i),THL_nn_idx(Nds(i)))];
    else
        while ~isempty(temp)
            THL_nn_idx(Nds(i))=THL_nn_idx(Nds(i))+1;
            temp=find(I_nn_VAT(:,1)==THL_nn_idx_nearest_K(Nds(i),THL_nn_idx(Nds(i))));
        end
        k=k+1;
        I_nn_VAT(k,:)=[Nds(i), THL_nn_idx_nearest_K(Nds(i),THL_nn_idx(Nds(i))), THL_dist_matrix_nearest_K(Nds(i),THL_nn_idx(Nds(i)))];
    end
%     p=plot3([data_x(I_nn_VAT(i,1)) data_x(I_nn_VAT(i,2))],[data_y(I_nn_VAT(i,1)) data_y(I_nn_VAT(i,2))],[data_t(I_nn_VAT(i,1)) data_t(I_nn_VAT(i,2))],'r'); hold on;
%     p.LineWidth = 3; hold on; xlabel('X axis'); ylabel('Y axis'); zlabel('E axis'); grid on;
end

G=graph(I_nn_VAT(1:length(data_idx)-1,1),I_nn_VAT(1:length(data_idx)-1,2),I_nn_VAT(1:length(data_idx)-1,3));

figure(4), RiV_without_dist_matrix=MST_iVAT(G.Edges.Weight); imagesc(RiV_without_dist_matrix); colormap gray; axis equal; axis off; % MST-iVAT image

% Unscaled dark blocks coordinagtes
clu_str=[1 15497 20076 49329 58319 65176];
clu_end=[15496 20075 49328 58318 65175 76500];

figure(5); % Scatter of ST data clustering for dnccVAT
for i=1:length(clu_str)
    subplot(1,2,1), scatter3(data_T(I_nn_VAT(clu_str(i):clu_end(i))),data_H(I_nn_VAT(clu_str(i):clu_end(i))),data_L(I_nn_VAT(clu_str(i):clu_end(i))),'filled'); axis square; xlabel('Temperature');ylabel('Humidity');zlabel('Light'); hold on;
    subplot(1,2,2), scatter3(data_x(I_nn_VAT(clu_str(i):clu_end(i))),data_y(I_nn_VAT(clu_str(i):clu_end(i))),data_t(I_nn_VAT(clu_str(i):clu_end(i))),'filled'); axis square; xlabel('X-axis');ylabel('Y-axis');zlabel('Epoch-time'); hold on;
end

run_time_of_code = toc
