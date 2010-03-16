function image1 = FFFART(x_s, y_s, x_d, y_d, N,image0,DetVal)
% RAYS = RAY_TRACER_2D(X_S, Y_S, X_D, Y_D, N)
% @input:
% X_S,Y_S: source coordinates
% X_D,Y_D: detector coordinates
% N: number of voxels
% @output:
% rays: sparse matrix containing weighting factors for the attenuation matrix used to compute a 
%       radon transform of the attenuation function.
%
% Computes lengths of ray-voxel intersections in a plane by tracing a ray from (x_s,y_s) to (x_d,y_d) through a grid of NxN voxels. The origin of the used coordinates system is in the center of the grid. 

% @author: Marta 
% @version: 1.0, 13.04.2007


%
M = N;


%tolerance for computation of sin/cos
tol = 1e-8;

%raise error if source or detector are inside of the grid
inside_error = true; 

%Initialization
rays = sparse(N,N);

%Coordinates of the vertical lines
grid_x = [-N/2:1:N/2]';
%Coordinates of the horizontal lines
grid_y = [-N/2:1:N/2]';

%Check if the source and detector are outside of the grid
if inside_error
  if abs(x_s) < N/2 & abs(y_s) < N/2 
    error(['Source inside the grid: (' num2str(x_s) ', ' num2str(y_s) ')']);
  end;
  if abs(x_d) < N/2 & abs(y_d) < N/2 
    error(['Detector inside the grid: )' num2str(x_d) ', ' num2str(y_d) ')']);
  end;
end;

%Find ang_ray_h
Lx = (grid_x(end)-grid_x(1)); 
x_sd = x_d - x_s;
y_sd = y_d - y_s;
%Reverse ray, such that it always forms an angle in [0,pi] with the horizontal axis 
if y_sd < 0
    y_sd = -y_sd;
    x_sd = -x_sd;
end
cos_ang_ray_h = Lx*x_sd/(sqrt(x_sd^2 + y_sd^2)*abs(Lx));

%Take care of the case of horizontal or vertical lines
if abs(cos_ang_ray_h) < tol % ang_ray_h ~ pi/2 -> vertical line
    cross = [x_s*ones(M+1,1), grid_y];
    %remove all crossings outside of the grid
    if x_s < grid_x(1) | x_s > grid_x(end)
        cross = [];
    else
       nr = length(find(x_s>=grid_x));
       if nr == M+1, nr = M; end;
       line_ind = [nr*ones(M+1,1), (1:M+1)'];
    end;
elseif abs(cos_ang_ray_h) > 1-tol % ang_ray_h ~ 0 or pi -> horizontal line
    cross = [grid_x,y_s*ones(N+1,1)];
    %remove all crossings outside of the grid
    if y_s < grid_y(1) | y_s > grid_y(end)
        cross = [];
    else
       nr = length(find(y_s>=grid_y));
       if nr == N+1, nr = N; end;    
       line_ind = [(1:N+1)', nr*ones(N+1,1)];  
    end
else  %for all other lines  
    ang_ray_h = acos(cos_ang_ray_h);
    tan_ang_ray_h = tan(ang_ray_h);
    %Compute the vectors of crossing points with horizontal lines
    cross_h = [(grid_y - y_s + tan_ang_ray_h*x_s)./tan_ang_ray_h, grid_y];
    %Compute the vectors of crossing points with vertical lines
    cross_v = [grid_x, tan_ang_ray_h.*grid_x + (y_s - tan_ang_ray_h*x_s)];
    %Order the crossing points in the order of the ray (growing y coordinate)
    if tan_ang_ray_h < 0
        %flipud cross_v that the ordering is the same as for the cross_h
        cross_v = flipud(cross_v);
    end;
    %merge the crossing points in order of growing y coordinate
    line_h = 1;
    line_v = 1;
    j = 1;
    cross = zeros((M+1+N+1),2);
    line_ind = zeros((M+1+N+1),2);
    doubles = 0;
    while j <= (M+1+N+1) & line_h <= length(cross_h) & line_v <= length(cross_v)
       if abs(cross_h(line_h,2) - cross_v(line_v,2)) < 10*eps %Crosses the vertical and horizontal axis in the same points
          cross(j,:) = cross_h(line_h,:);
          line_ind(j,:) = [line_v,line_h];
          line_h = line_h + 1;   
          line_v = line_v + 1;
          doubles = doubles + 1;
       elseif cross_h(line_h,2) < cross_v(line_v,2)
          cross(j,:) = cross_h(line_h,:);
          line_ind(j,:) = [line_v-1,line_h];
          line_h = line_h + 1;
       else
          cross(j,:) = cross_v(line_v,:);         
          line_ind(j,:) = [line_v, line_h-1];
          line_v = line_v + 1;
       end
       j = j+1;
    end
    if j + doubles <= (M+1+N+1) & line_h > length(cross_h)
       cross(j:end-doubles,:) = cross_v(line_v:end,:);
       line_ind(j:end-doubles,:) = [(line_v:size(cross_v,1))', (line_h-1)*ones(size(cross_v,1)-line_v+1,1)];
    elseif j + doubles <= (M+1+N+1) & line_v > length(cross_v)
       cross(j:end-doubles,:) = cross_h(line_h:end,:);
       line_ind(j:end-doubles,:) = [(line_h:size(cross_h,1))', (line_v-1)*ones(size(cross_h,1)-line_h+1,1)];
    end;
    %Crop cross and line_ind
    if doubles > 0
       cross = cross(1:((M+1+N+1)-doubles),:);
       line_ind = line_ind(1:((M+1+N+1)-doubles),:);
    end;
    %Discard crossing outside of the grid
    outsiders_x = find(cross(:,1) < grid_x(1)-10*eps | cross(:,1) > grid_x(end)+10*eps);
    outsiders_y = find(cross(:,2) < grid_y(1)-10*eps | cross(:,2) > grid_y(end)+10*eps);
    outsiders = sort(union(outsiders_x, outsiders_y));
    insiders = setdiff(1:length(cross), outsiders);
    cross = cross(insiders,:);
    line_ind = line_ind(insiders,:);
    if tan_ang_ray_h < 0
       %adjust the numbers of vertical lines which were numbered in the discending direction
        line_ind(:,1) = N+1 - line_ind(:,1);
    end;
end       

  %projection

%   if ~isempty(cross)
%       line_ind_len = length(line_ind);
%       for i = 1: size(line_ind,1)-1
%           row = line_ind(i,2);
%           col = line_ind(i,1);
%           
%           DetVal = DetVal + image(row,col);
%       end
%   end
if ~isempty(cross)
   %Compute distances and voxel coordinates (verctorized)
   vs = (cross(2:end,:)-cross(1:end-1,:));
   v_lens = sqrt(vs(:,1).^2+vs(:,2).^2);
  
   %Assign rays lengths and return a sparse matrix
%                                      p_k+1-w_k+1'* x_k
%          x_k+1 =  x_k +     w_k+1 * -------------------
%                                     norm(w_k+1)*norm(w_k+1)

% get (w_k+1'* x_k) and norm(w_k+1)*norm(w_k+1)
 sumWX = 0;
 sumWW = 0;
  for j = 1:size(line_ind,1)-1
      rays(line_ind(j,2),line_ind(j,1)) = v_lens(j);
      %-------------add------------
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %v_lens(j)=1;
       %%%%%%%%%%%%%%%%%%%%%%%%%%
       row = line_ind(j,2);
       col = line_ind(j,1);
       sumWX =  sumWX + image0(row,col)*v_lens(j);
       sumWW =  sumWW + v_lens(j)*v_lens(j);
       %------------------------------
   end;
   %            p_k+1-w_k+1'* x_k
   %          -------------------
   %          norm(w_k+1)*norm(w_k+1)

   SPara = (DetVal-sumWX)/sumWW;

   
   %image1
   image1=image0;
   for j = 1:size(line_ind,1)-1
      rays(line_ind(j,2),line_ind(j,1)) = v_lens(j);
      %-------------add------------
      % 
       row = line_ind(j,2);
       col = line_ind(j,1);
       image1(row,col) = v_lens(j) * SPara + image1(row,col);
       %------------------------------
   end;
end;



   