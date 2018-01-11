function label=comp_label(varargin)
% Tianyang Chen


I = varargin{1};
%I = imread('keys.png');
% if you want to find 0-pixel components, set fg=0; if you want to find non-0 pixel components, set fg=255
fg=0;

[row,col]=size(I);% get the row and col of image
label=zeros(row,col);
nextlabel=1;
for r=1:row
    for c=1:col
        if I(r,c)==fg
            label(r,c)=nextlabel;% set each fg pixel a non-0 number
            nextlabel=nextlabel+1;
        end
    end
end
for k=1:5
    m=row*col;
    for r=1:row
        for c=1:col%scan the image from top to bottom
            if label(r,c) ~= 0
                for i=r-1:r+1
                    for j=c-1:c+1
                        if label(i,j)~=0 && label(i,j)<m
                            m=label(i,j);% find the minimum non-0 label among (r,c) and its neighbors
                        end
                    end
                end
                if label(r,c) ~= m
                    label(r,c)=m;
                end
                m=row*col;
            end
        end
    end
    m=row*col;
    for r=row:-1:1
        for c=col:-1:1%scan the image from bottom to top
            if label(r,c) ~= 0
                for i=r-1:r+1
                    for j=c-1:c+1
                        if label(i,j)~=0 && label(i,j)<m
                            m=label(i,j);% find the minimum non-0 label among (r,c) and its neighbors
                        end
                    end
                end
                if label(r,c) ~= m
                    label(r,c)=m;
                end
                m=row*col;
            end
        end
    end
end
% scale the pixel value to (0,255)
n_region=length(unique(label))-1;
region=unique(label);
for r=1:row
    for c=1:col
        if label(r,c)~=0
            n_scale=find(label(r,c)==region)-1;
            label(r,c)=round(n_scale*255/n_region);
        end
    end
end
Agray = uint8(label);

% imwrite(Agray,varargin{2});
%imwrite(Agray,'keysoutput.png');
end

