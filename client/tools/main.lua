
require ("libs.json_wrap")
require ("functions")
require ("lfs")

local button_strip = {

	btn_nor = {
		key = "_N$normalSprite";
		uuid = "f0048c10-f03e-4c97-b9d3-3506e1d58952"
	};
	
	btn_pre = {
		key = "_N$pressedSprite";
		uuid = "e9ec654c-97a2-4787-9325-e6a10375219a"
	};
	
	btn_pre1 = {
		key = "pressedSprite";
		uuid = "e9ec654c-97a2-4787-9325-e6a10375219a"
	};
	
	btn_hov = {
		key = "_N$hoverSprite";
		uuid = "e9ec654c-97a2-4787-9325-e6a10375219a"
	};
	
	btn_hov1 = {
		key = "hoverSprite";
		uuid = "e9ec654c-97a2-4787-9325-e6a10375219a"
	};
	
	btn_hov2 = {
		key = "hoverSprite";
		uuid = "f0048c10-f03e-4c97-b9d3-3506e1d58952"
	};
	
	btn_hov2 = {
		key = "_N$hoverSprite";
		uuid = "f0048c10-f03e-4c97-b9d3-3506e1d58952"
	};
	
	btn_dis = {
		key = "_N$disabledSprite";
		uuid = "29158224-f8dd-4661-a796-1ffab537140e"
	};
	
}

local spr_stip = {
	nor = {
		key = "_spriteFrame";
		uuid = "8cdb44ac-a3f6-449f-b354-7cd48cf84061";
	}
	;
	nor1 = {
		key = "_spriteFrame";
		uuid = "5c3bb932-6c3c-468f-88a9-c8c61d458641";
	}
	;
	nor2 = {
		key = "_spriteFrame";
		uuid = "a23235d1-15db-4b95-8439-a2e005bfff91";
	}
	;
};

local scroll_strip = {
	nor = {
		key = "";
		uuid = "";
	}
}

function attrdir(path,callback)
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local f = path.. '/' ..file
			local attr = lfs.attributes (f)
			if attr then 
				if attr.mode == "directory" then
					attrdir(f,callback)
				else
					if callback then 
						callback (f);
					end
				end
			end
		end
	end
end

local basedir = "../assets/";

function walk_tree (node) 
	
	local tp = type (node) ;
	
	if tp == "table" or tp == "userdata" then 
		for k , v in pairs (node) do 
			
			local vtp = type (v);
			if vtp == "table" or vtp == "userdata" then 
				if v.__type__ == "cc.Button"  then 
					
					for gk , gv in pairs (button_strip) do 
						if v [gv.key] and v [gv.key].__uuid__ and v [gv.key].__uuid__ == gv.uuid then 
							-- print ("strip attributes");
							v [gv.key] = nil;
						end 
					end
					
				end
				
				if v.__type__ == "cc.Sprite"  then 
				
					for gk , gv in pairs (spr_stip) do 
						if v [gv.key] and v [gv.key].__uuid__ and v [gv.key].__uuid__ == gv.uuid then 
							-- print ("strip attributes");
							v [gv.key] = nil;
						end 
					end
					
				end
				
				
			end 
			
			walk_tree (v);
		end
	else 
		-- print (node);
	end
	
end


function getExtension(str)
	return str:match(".+%.(%w+)$")
end

function strip (path) 
	
	local ext  = getExtension (path);
	
	if ext == "fire" or ext == "prefab" then 

		local file = io.open (path,"r");
		local tofile = io.open (path .. "." .. ext,"w");
		
		if file and tofile then 
			
			print ("strip file " .. path);
			
			local content = file:read ("*a");
			local obj = json.decode(content);
			
			if (obj) then
				walk_tree (obj);
				-- print ("jstring = " .. json.encode(obj));
				tofile:write (json.encode(obj));
			end
			
		end
		
		if file then 
			file:close ();
		end 
		
		if tofile then 
			tofile:close ();
		end 
		
		os.remove (path);
		os.rename (path .. "." .. ext,path);
		
		
	end
end

attrdir (basedir,function (path) 
	
	strip (path);
	
end );


-- strip (basedir .. "04/044d5ce87.21dfe.json");




