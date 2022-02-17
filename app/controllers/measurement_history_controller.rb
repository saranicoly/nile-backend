class MeasurementHistoryController < ApplicationController
    require 'prawn'
    require 'prawn/table'

    def index
        measure_history = []
        data.reverse.each do | measure |
            measurement_date = measure[:datetime].to_datetime.strftime("%d/%m/%Y %H:%M")
            measure.map do | key, value |
                unless key == :datetime
                    measure_history << [measurement_date, key, value]
                end
            end
        end
        # puts weekly_measure
        render json: weekly_measure

        # generate_pdf
        # redirect_to '/measurements_history.pdf'
    end

    private

    def data
        firestore = firebase_connection
        measured_data = firestore.col "device_data"

        return measured_data.get.map { |measure| measure.data }.sort_by { |measure| measure[:datetime] }
    end

    def generate_pdf
        # Apenas uma string aleatório para termos um corpo de texto pro contrato
        lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec elementum nulla id dignissim iaculis. Vestibulum a egestas elit, vitae feugiat velit. Vestibulum consectetur non neque sit amet tristique. Maecenas sollicitudin enim elit, in auctor ligula facilisis sit amet. Fusce imperdiet risus sed bibendum hendrerit. Sed vitae ante sit amet sapien aliquam consequat. Duis sed magna dignissim, lobortis tortor nec, suscipit velit. Nulla sit amet fringilla nisl. Integer tempor mauris vitae augue lobortis posuere. Ut quis tellus purus. Nullam dolor mauris, egestas varius ligula non, cursus faucibus orci sectetur non neque sit amet tristique. Maecenas sollicitudin enim elit, in auctor ligula facilisis sit amet. Fusce imperdiet risus sed bibendum hendrerit. Sed vitae ante sit amet sapien aliquam consequat."
    
        Prawn::Document.new(pdf_options = {:page_size => "A4", :page_layout => :portrait, :margin => [40, 75]}) do |pdf|
          # Define a cor do traçado
          pdf.fill_color "666666"
          # Cria um texto com tamanho 30 PDF Points, bold alinha no centro
          pdf.text "Measurement History", :size => 32, :style => :bold, :align => :center
          # Move 80 PDF points para baixo o cursor
          pdf.move_down 80
          # Escreve o texto do contrato com o tamanho de 14 PDF points, com o alinhamento justify
          pdf.text "#{lorem_ipsum}", :size => 12, :align => :justify, :inline_format => true
          # Inclui em baixo da folha do lado direito a data e o némero da página usando a tag page
          pdf.number_pages "Generated: #{(Time.now).strftime("%d/%m/%y as %H:%M")} - Página ", :start_count_at => 0, :page_filter => :all, :at => [pdf.bounds.right - 140, 7], :align => :right, :size => 8
          # Gera no nosso PDF e coloca na pasta public com o nome agreement.pdf
          pdf.render_file('public/measurements_history.pdf')
        end
    end
end