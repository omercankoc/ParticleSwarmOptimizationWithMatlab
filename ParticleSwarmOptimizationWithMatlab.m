
clc;clear all;close all;
%% initialization
% baþlatýlýyor...
swarm_size = 64;                       % suru parcaciklarinin sayisi
maxIter = 50;                          % maximum iterasyon sayisi
inertia = 1.0;                         % cýkýs kosulu
correction_factor = 2.0;               % düzeltim
% ilk sürülerin yerlerini ayarlama
a = 1:8;                               %a=(1,2,3,4,5,6,7,8)
[X,Y] = meshgrid(a,a);
C = cat(2,X',Y');
D = reshape(C,[],2);
swarm(1:swarm_size,1,1:2) = D;         % parcaciklarin 2D konumunu ayarla
swarm(:,2,:) = 0;                      % partikullerin baslangýc hizini ayarla
swarm(:,4,1) = 1000;                   % simdiye kadar ki en iyi deðeri ayarla
plotObjFcn = 1;                        % set to zero if you do not need a final plot

%% define the objective funcion here (vectorized form)
%  Amac Fonksiyonu tanýmlanýyor...
objfcn =  @(x)(x(:,1) - 20).^2 + (x(:,2) - 25).^2;

tic;
%% The main loop of PSO
%  PSO 
for iter = 1:maxIter
    swarm(:, 1, 1) = swarm(:, 1, 1) + swarm(:, 2, 1)/1.3;       % x pozisyonunun hýzýný guncelle...
    swarm(:, 1, 2) = swarm(:, 1, 2) + swarm(:, 2, 2)/1.3;       % y pozisyonunun hýzýný guncelle...
    x = swarm(:, 1, 1);                                         % güncellenmis pozisyon alýnýyor...
    y = swarm(:, 1, 2);                                         % güncellenmis pozisyon...
    fval = objfcn([x y]);                                       % parcacýgýn konumunu kullanarak amac fonksiyonu isle
    
    % en iyi global çözümleri bulmak icin local cözümleri
    % karsilastýracaksin(!)
    for ii = 1:swarm_size
        if fval(ii,1) < swarm(ii,4,1)
            swarm(ii, 3, 1) = swarm(ii, 1, 1);                  % en iyi x pozisyonunu guncelle
            swarm(ii, 3, 2) = swarm(ii, 1, 2);                  % en iyi y pozisyonunu guncelle
            swarm(ii, 4, 1) = fval(ii,1);                       % global en iyi cozumu guncelle
        end
    end
    
    [~, gbest] = min(swarm(:, 4, 1));                           % toplamda en iyi fonksiyon degerini bul
    
    % parcacýklarin hizini guncelle
    swarm(:, 2, 1) = inertia*(rand(swarm_size,1).*swarm(:, 2, 1)) + correction_factor*(rand(swarm_size,1).*(swarm(:, 3, 1) ...
        - swarm(:, 1, 1))) + correction_factor*(rand(swarm_size,1).*(swarm(gbest, 3, 1) - swarm(:, 1, 1)));   % x hýz bileseni
    swarm(:, 2, 2) = inertia*(rand(swarm_size,1).*swarm(:, 2, 2)) + correction_factor*(rand(swarm_size,1).*(swarm(:, 3, 2) ...
        - swarm(:, 1, 2))) + correction_factor*(rand(swarm_size,1).*(swarm(gbest, 3, 2) - swarm(:, 1, 2)));   % y hýz bileseni
    
    % parcacýklarýn grafigi
    clf;plot(swarm(:, 1, 1), swarm(:, 1, 2), 'bx');            % suru hareketlerini goruntule...
    axis([-2 40 -2 40]);
    pause(.1);                                                 % animasyon hýzýný azaltýyormus(!)
    disp(['iteration: ' num2str(iter)]);
end
toc
%% plot the function
%  fonksiyon grafigi
if plotObjFcn
    ub = 40;
    lb = 0;
    npoints = 1000;
    x = (ub-lb) .* rand(npoints,2) + lb;
    for ii = 1:npoints
        f = objfcn([x(ii,1) x(ii,2)]);
        plot3(x(ii,1),x(ii,2),f,'.r');hold on
    end
    plot3(swarm(1,3,1),swarm(1,3,2),swarm(1,4,1),'xb','linewidth',5,'Markersize',5);grid
end
