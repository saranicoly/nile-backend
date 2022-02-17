class MeasurementHistoryController < ApplicationController
    require 'prawn/table'
    require 'prawn'

    def index
        measure_history = []
        count = 0
        data.reverse.each do | measure |
            count += 1
            unless count > 40
                measurement_date = measure[:datetime].to_datetime.strftime("%d/%m/%Y %H:%M")
                measure.map do | key, value |
                    unless key == :datetime
                        measure_history << [measurement_date, key.to_s, value.to_s]
                    end
                end
            end
        end

        generate_pdf(measure_history)
        redirect_to '/measurements_history.pdf'
    end

    private

    def data
        firestore = firebase_connection
        measured_data = firestore.col "device_data"

        return measured_data.get.map { |measure| measure.data }.sort_by { |measure| measure[:datetime] }
    end

    def generate_pdf(measure_history)
        Prawn::Document.new(pdf_options = {:page_size => "A4", :page_layout => :portrait, :margin => [40, 75]}) do |pdf|
          # Define a cor do traçado
          pdf.fill_color "666666"
          # Cria um texto com tamanho 30 PDF Points, bold alinha no centro
          pdf.text "Measurement History", :size => 32, :style => :bold, :align => :center
          # Move 80 PDF points para baixo o cursor
          pdf.move_down 80
          # Escreve o texto do contrato com o tamanho de 14 PDF points, com o alinhamento justify
          table_data = [["Date", "Sensor", "Value"]]
          table_data += measure_history
          pdf.table(table_data, :header => true, :width => 500, :row_colors => ["F0F0F0", "FFFFFF"])
          # Inclui em baixo da folha do lado direito a data e o némero da página usando a tag page
          pdf.number_pages "Generated: #{(Time.now).strftime("%d/%m/%y at %H:%M")}", :page_filter => :all, :at => [pdf.bounds.right - 140, 7], :align => :right, :size => 8
          # Gera no nosso PDF e coloca na pasta public com o nome agreement.pdf
          pdf.render_file('public/measurements_history.pdf')
        end
    end
end