function out=omr(varargin)

I=imread(varargin{1});
I=imbinarize(I);
imwrite(I,'bw.png');
[row,col]=size(I);
black_pixel=zeros(1,row);
for r=1:row
    black_pixel(r)=length(find(I(r,:)==0));
end
plot(1:row,black_pixel);
staff_line=find(black_pixel>(max(black_pixel)/2));
staff_line=uint16(staff_line);
I(staff_line,:)=1;
% imwrite(I,'2.png');
for i=1:length(staff_line)
    for c=1:col
        if I(staff_line(i)-1,c)==0 && I(staff_line(i)+1,c)==0
            I(staff_line(i),c)=0;
        end
    end
end
imwrite(I,'remove_staff_line.png');
number_of_lines=round(length(staff_line)/5);
sum_staff_interval=0;
for i=1:number_of_lines
    sum_staff_interval=sum_staff_interval+staff_line(5*i)-staff_line(5*i-4);
end
staff_interval=sum_staff_interval/(4*number_of_lines);


label=comp_label(I);
unique_label=unique(label);
num_unique_label=length(unique_label);
box=zeros(num_unique_label-1,4);
for i=2:num_unique_label;
    [x,y]=find(label==unique_label(i));
    box(i-1,1)=min(y);
    box(i-1,2)=max(y);
    box(i-1,3)=min(x);
    box(i-1,4)=max(x);
end
for i=1:(num_unique_label-1)
    if box(i,4)-box(i,3)>(5*staff_interval) || box(i,2)-box(i,1)<(0.5*staff_interval) || (box(i,4)-box(i,3)>=(1.33*double(staff_interval))&&box(i,4)-box(i,3)<=(3*staff_interval))
        [x,y]=find(label==unique_label(i+1));
        for j=1:length(x)
            I(x(j),y(j))=1;
        end
    end
end
imwrite(I,'get_notes.png');



label_note=comp_label(I);
unique_label_note=unique(label_note);
number_label_note=length(unique_label_note);
melody=zeros(number_label_note-1,3);
note_box=zeros(number_label_note-1,4);

for i=2:number_label_note;
    [x,y]=find(label_note==unique_label_note(i));
    note_box(i-1,1)=min(y);
    note_box(i-1,2)=max(y);
    note_box(i-1,3)=min(x);
    note_box(i-1,4)=max(x);
end
for i=1:number_of_lines
    line{i}=[];
end

for j=1:(number_label_note-1)
    line{floor(note_box(j,4)/row*number_of_lines)+1}=[line{floor(note_box(j,4)/row*number_of_lines)+1}; note_box(j,:)];
end
for i=1:number_of_lines
    line{i}=sortrows(line{i},1);
end
melody(:,2)=2;
note_index=0;
for i=1:number_of_lines
    for j=1:length(line{i})
        if (line{i}(j,4)-line{i}(j,3))>1.6*(line{i}(j,2)-line{i}(j,1))
            note_index=0;
            for k=1:i
                note_index=note_index+length(line{k});
            end
            note_index=note_index-length(line{i})+j;
            check_line=I(line{i}(j,3):line{i}(j,4),round((line{i}(j,1)+line{i}(j,2))/2));
            check_black=find(check_line==0);
            if (max(check_black)-min(check_black)+1)>length(check_black)
                melody(note_index,3)=1/2;
            else
                melody(note_index,3)=1/4;
            end
        else
            note_index=0;
            for k=1:i
                note_index=note_index+length(line{k});
            end
            note_index=note_index-length(line{i})+j;
            check_line=I(line{i}(j,3):line{i}(j,4),round((line{i}(j,1)+line{i}(j,2))/2));
            melody(note_index,3)=1;
        end
    end
end
note_index=0;
for i=1:number_of_lines
    for j=1:length(line{i})
        note_index=note_index+1;
        
        distan=double((line{i}(j,4)-double(staff_interval)/2-double(staff_line(5*i-4)))/double(staff_interval));
        sigmao=2/double(staff_interval);
        
        if distan<=5+sigmao && distan>=5-sigmao
            melody(note_index,1)=1;
        else
            if distan<5-sigmao && distan>4+sigmao
                melody(note_index,1)=2;
            else
                if distan>=4-sigmao && distan<=4+sigmao
                    melody(note_index,1)=3;
                else
                    if distan<4-sigmao && distan>3+sigmao
                        melody(note_index,1)=4;
                    else
                        if distan>=3-sigmao && distan<=3+sigmao
                            melody(note_index,1)=5;
                        else
                            if distan<3-sigmao && distan>2+sigmao
                                melody(note_index,1)=6;
                            else
                                if distan>=2-sigmao && distan<=2+sigmao
                                    melody(note_index,1)=7;
                                else
                                    if distan<2-sigmao && distan>1+sigmao
                                        melody(note_index,1)=1;
                                        melody(note_index,2)=3;
                                    else
                                        if distan>=1-sigmao && distan<=1+sigmao
                                            melody(note_index,1)=2;
                                            melody(note_index,2)=3;
                                            
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
xlswrite(varargin{2},melody);
playmusic(melody);
end

