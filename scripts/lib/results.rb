require 'json'
require 'optparse'

class Results

  def self.pack(**args)
    Results.new(**args).calculate.pack
  end

  def self.calculate(**args)
    Results.new(**args).calculate
  end

  def self.get_results_data(path:)
    fail(StandardError, "'#{path}' is not a directory") if !File.directory?(path)

    return get_results_data_from_dir(directory: path)
  end

  def initialize(dst_path:, src_directory:, spec_file:, dataset:)
    @src_directory = src_directory
    @dst_path = dst_path
    @spec_file = spec_file.to_s
    @dataset = dataset

    @data = { spec_file: spec_file, dataset: dataset }
    @included_files = []
  end

  def calculate
    write_commit
    write_date
    write_overlaps_info
    write_unitigs_info
    write_contigs_info
    include_drawed_assembly_files
    include_dataset_file
    include_spec_files

    @data[:included_files] = @included_files

    write_data

    self
  end

  def pack
    tmp_dir = File.join('/tmp', "ra_results_#{Time.now.to_i}")
    Dir.mkdir(tmp_dir)

    @included_files.each do |file|
      `cp #{file} #{tmp_dir}`
    end

    files = @included_files.map{ |file| File.basename(file) }.join(' ')
    `tar -C #{tmp_dir} -cvzf #{@dst_path} #{files}`

    `rm -r #{tmp_dir}`

    self
  end

  private
  def self.get_results_data_from_dir(directory:)
    results_path = File.join(directory, 'results.json')
    fail(StandardError, "File '#{results_path}' does not exist") if !File.file?(results_path)

    return JSON.parse(File.read(results_path))
  end

  def write_data
    results_path = File.join(@src_directory, 'results.json')

    @data[:included_files].push(results_path)

    f = File.new(results_path, 'w')
    f.write(@data.to_json)
    f.close
  end

  def include_spec_files
    @included_files.push(@spec_file) if File.file?(@spec_file)

    Dir.entries(@src_directory).each do |node|
      next if node.rindex('.spec') != node.size - '.spec'.size

      spec_path = File.join(@src_directory, node)
      if (!File.file?(spec_path))
        STDERR.puts "#{spec_path} does not exist, skipping "
        return
      end

      @included_files.push(spec_path)
    end
  end

  def include_drawed_assembly_files
    genome_in_svg = File.join(@src_directory, 'genome.svg')
    if (!File.file?(genome_in_svg))
      STDERR.puts "#{genome_in_svg} does not exist, skipping"
      return
    end

    @included_files.push(genome_in_svg)
  end

  def include_dataset_file
    if (!File.file?(@dataset))
      fail(StandardError, "File '#{@dataset}' does not exist")
      return
    end

    @included_files.push(@dataset)
  end

  def write_date
    @data[:report_created_at] = Time.now
  end

  def write_commit
    dir = File.dirname(File.dirname(__FILE__))
    cmd = "git -C #{dir} rev-parse HEAD"
    @data[:commit_sha1] = `#{cmd}`.strip
  end

  def write_unitigs_info
    unitigs_path = File.join(@src_directory, 'unitigs_fast.fasta')
    if (!File.file?(unitigs_path))
      STDERR.puts "#{unitigs_path} does not exist, skipping unitigs info"
      return
    end

    @included_files.push(unitigs_path)

    i = 0
    unitig_sizes = []
    File.open(unitigs_path).each do |line|
      i += 1
      next if i % 2 == 1
      unitig_sizes.push(line.size)
    end

    @data[:unitigs_count] = unitig_sizes.size
    unitig_sizes.sort_by{ |len| -len }.take(5).each_index do |k|
      @data[:"unitig_#{k + 1}_size"] = unitig_sizes[k]
    end
  end

  def write_contigs_info
    contigs_path = File.join(@src_directory, 'contigs_fast.fasta')
    if (!File.file?(contigs_path))
      STDERR.puts "#{contigs_path} does not exist, skipping contigs info"
      return
    end

    @included_files.push(contigs_path)

    i = 0
    unitig_sizes = []
    File.open(contigs_path).each do |line|
      i += 1
      next if i % 2 == 1
      unitig_sizes.push(line.size)
    end

    @data[:contigs_count] = unitig_sizes.size
    unitig_sizes.sort_by{ |len| -len }.take(5).each_index do |k|
      @data[:"contig_#{k+1}_size"] = unitig_sizes[k]
    end
  end

  def write_overlaps_info
    Dir.entries(@src_directory).each do |node|
      next if node.index('overlaps.') != 0

      overlaps_path = File.join(@src_directory, node)
      if (!File.file?(overlaps_path))
        STDERR.puts "#{overlaps_path} does not exist, skipping"
        return
      end

      @included_files.push(overlaps_path)

      @data[:"#{node}_count"] = File.open(overlaps_path).readlines.count
    end
  end
end
