# Hobo-jqGrid

class HVModels
  @@hvmodels = {}
  @@hvmodel_string = "| "
  def self.add(model)
    @@hvmodels[model] = model
    @@hvmodel_string = @@hvmodel_string + model + " | "
  end
  
  def self.names
    @@hvmodel_string
  end
  
  def self.isModel(model_name)
    @@hvmodel_string.include?('| ' + model_name + ' |')
  end
  
  def self.cls(key)
    @@hvmodels[key]
  end

end

class JqgridRequest
  
  def self.add(jqgrid_id,colmodel)
    elfed = elfhash(colmodel).to_s
    pcolmodel = Colmodel.find(:all,:conditions => [ "jqgrid_id = ?", jqgrid_id ])
    if pcolmodel.length>0
      pcolmodel.each do |x|
        puts "ELFN:" + elfed    + ":"
        puts "ELFS:" + x["elf"] + ":"
        if x["elf"]!=elfed
          x["elf"]      = elfed
          x["colmodel"] = colmodel
          x.save
        end
      end
    else
      x = Colmodel.new
      x["jqgrid_id"] = jqgrid_id
      x["elf"]       = elfed
      x["colmodel"]  = colmodel
      x.save
    end
  end
  
  def self.get(jqgrid_id)
    jvp = JvJsonParser.new
    result = nil
    pcolmodel = Colmodel.find(:all,:conditions => [ "jqgrid_id = ?", jqgrid_id ])
    if pcolmodel.length>0
      pcolmodel.each do |x|
        result = jvp.parse('[' + x["colmodel"] + ']')
      end
    else
      raise "Colmodel store not found!"
    end
    result
  end
  
  def self.elfhash( str, len=str.length )
    hash = 0
    x = 0
    len.times{ |i|
      hash = (hash << 4) + str[i]
      if  (x = hash & 0xF0000000) != 0
        hash ^= (x >> 24)
        hash &= ~x
      end
    }
    return hash
  end  
  
end

def mysql_escape(s)
  s.gsub('\\','\\\\\\\\\\\\\\\\').gsub("'","\\\\\\\\\\\\'").gsub('%',"\\\\\\\\\\\%")
end

class ApplicationController < ActionController::Base
  protect_from_forgery #:secret => '9d4f1430ede93ccb54d2793e523a9c45'
  def jqgrid_json
    
    controller = params["id"]     ||= '*'
    controller = params["controller"] if (controller=='*')
    
    rows       = params["rows"]   ||= '-1'
    search     = params["search"] ||= 'false'
    page       = params["page"]   ||= '1'
    sidx       = params["sidx"]   ||= ''
    sord       = params["sord"]   ||= 'ASC'
    
    sidx.gsub!(/[^\w_]/,'')
    sord.gsub!(/[^\w_]/,'')
    
    pmodel = controller.split('__')
    model = pmodel[0].singularize.camelize
    rqid = pmodel[1]
    colmodel = JqgridRequest.get(rqid)
    field_array = []
    colmodel.each do |x|
      x.each_pair do |k,v|
        if k=='name'
          field_array << v
        end
      end
    end
    
    logger.info('rows: ' + params["rows"])
    logger.info('params: ')
    params.each do |p|
      logger.info(p.to_s)
    end
    
    logger.info('rows,page : ' + rows.to_s + ',' + page.to_s)

    if HVModels.isModel(model)
      
      sch = ""
      if (params.has_key?("_search") and params.has_key?("searchField") and params.has_key?("searchOper") and params.has_key?("searchString") and (params["_search"]=='true'))
        logger.info("SEARCHING!!!")
        sch = ",:conditions => '"
        ss = mysql_escape(params["searchString"])
        case params["searchOper"]
          when 'bw'
            sch += params["searchField"] + ' LIKE \\\'' + ss + '%\\\''
          when 'bn'
            sch += params["searchField"] + ' NOT LIKE \\\'' + ss + '%\\\''
          when 'eq'
            sch += params["searchField"] + ' = \\\'' + ss + '\\\''
          when 'ne'
            sch += params["searchField"] + ' <> \\\'' + ss + '\\\''
          when 'lt'
            sch += params["searchField"] + ' < \\\'' + ss + '\\\''
          when 'le'
            sch += params["searchField"] + ' <= \\\'' + ss + '\\\''
          when 'gt'
            sch += params["searchField"] + ' > \\\'' + ss + '\\\''
          when 'ge'
            sch += params["searchField"] + ' >= \\\'' + ss + '\\\''
          when 'ew'
            sch += params["searchField"] + ' LIKE \\\'%' + ss + '\\\''
          when 'en'
            sch += params["searchField"] + ' NOT LIKE \\\'%' + ss + '\\\''
          when 'cn'
            sch += params["searchField"] + ' LIKE \\\'%' + ss + '%\\\''
          when 'nc'
            sch += params["searchField"] + ' NOT LIKE \\\'%' + ss + '%\\\''
          when 'in'
            sch += params["searchField"] + ' IN (' + params["searchString"] + ')'
          when 'ni'
            sch += params["searchField"] + ' NOT IN (' + params["searchString"] + ')'
        end
        sch += "'"
      end
      
      cex = model + '.count(:all' + sch + ')'
      logger.info(cex)
      rcount = eval(cex)

      ex = model + '.find(:all' + sch
      irows = rows.to_i
      unless (irows<1)
        ex = ex + ',:limit => ' + rows 
        offset = ((irows * page.to_i) - irows)
        while offset>rcount
          offset = offset - irows 
          page = (page.to_i - 1).to_s
        end
        if offset<0
          offset = 0 
          page = "1"
        end
        ex = ex + ',:offset => ' + offset.to_s 
      end
      ex = ex + ',:order => "' + sidx + ' ' + sord + '"' unless (sidx=='')
      ex = ex + ')'
      logger.info('!!!' + ex)
      
      recs = eval(ex)
      
      recs.each do |x|
        logger.info(x.to_s)
      end
      
      logger.info('to_json: ' + recs.to_json().to_s)
      
      jresult = {}
      
      if rows.to_i>0
        
      end
      
      if rows.to_i>0
        
        jresult["page"] = page
        jresult["total"] = rcount / rows.to_i
        jresult["total"] += 1 if (rcount % rows.to_i) > 0
        jresult["records"] = rcount.to_s
        
      else
        
        jresult["page"] = "1"
        jresult["total"] = 1
        jresult["records"] = recs.length.to_s
        
      end
      
      jresult["rows"] = []
      
      recs.each do |r|
        cur = []
        field_array.each do |f|
          cur << r[f] 
        end
        jresult["rows"] << { "id" => r["id"], "cell" => cur}
      end
      
      logger.info('other_json: ' + jresult.to_json)
      
      render :json => jresult.to_json, :status => 200
    else
      raise "Unable to locate model: " + model
    end
    
  end
  
  def jqgrid_edit_json
    logger.info('params: ')
    params.each_pair do |k,v|
      logger.info( k.to_s + ' : ' + v.to_s)
    end
    controller = params["id"] ||= '*'
    controller = params["controller"] if (controller=='*')
    oper = params["oper"]
    case oper
      when 'del'
        rid = params["record_id"]
        logger.info(rid + " : " + rid.gsub(/[^\d]/,''))
        if (rid==rid.gsub(/[^\d]/,''))
          pmodel = controller.split('__')
          model = pmodel[0].singularize.camelize
          if HVModels.isModel(model)
            ex = model + '.delete(' + rid + ')'
            logger.info(ex)
            res = eval(ex)
            logger.info("result - " + res.to_s)
            if (res==1)
              render :text => '', :status => 200
            else
              render :text => '', :status => 404
            end
          else
            render :text => '', :status => 406
          end
        else
          render :text => '', :status => 406
        end
      when 'edit'
        rid = params["record_id"]
        logger.info(rid + " : " + rid.gsub(/[^\d]/,''))
        if (rid==rid.gsub(/[^\d]/,''))
          pmodel = controller.split('__')
          model = pmodel[0].singularize.camelize
          if HVModels.isModel(model)
            ex = model + '.find(' + rid + ')'
            logger.info(ex)
            rec = eval(ex)
            atts = rec.attributes
            changed_atts = {}
            changed = false
            rec.attributes.each do |x|
              unless (x[0]=='id' or x[0]=='oper' or x[0]=='record_id' or x[0]=='controller' or x[0]=='authenticity_token')
                if params[x[0]]
                  if (atts[x[0]].to_s!=params[x[0]].to_s)
                    changed_atts[x[0]]=params[x[0]]
                    changed = true
                  end
                end
              end
            end
            if changed
              logger.info("changed atts: " + changed_atts.to_s)
              if rec.update_attributes!(changed_atts)
                render :text => '', :status => 200
              end
            else
              render :text => '', :status => 400
            end
          else
            render :text => '', :status => 406
          end
        else
          render :text => '', :status => 406
        end
      when 'add'
        pmodel = controller.split('__')
        model = pmodel[0].singularize.camelize
        if HVModels.isModel(model)
          new_atts = {}
          params.each_pair do |k,v|
            unless (k=='id' or k=='oper' or k=='record_id' or k=='controller' or k=='authenticity_token' or k=='action')
              new_atts[k] = v
            end
          end
          ex = model + '.create(new_atts)'
          logger.info(ex)
          if eval(ex)
            render :text => '', :status => 200
          end
        else
          render :text => '', :status => 406
        end
      else
        render :text => '', :status => 406
    end
  end
  
end

class << ActiveRecord::Base
  alias_method :inherited_without_extras, :inherited

  def inherited(sub)
    HVModels.add(sub.to_s)
    inherited_without_extras(sub)
  end
  
end


