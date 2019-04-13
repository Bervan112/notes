<div class="copyright">

  <a target="_blank" href="http://www.miitbeian.gov.cn/" rel="external nofollow"> 粤ICP备14001098号-1 </a>
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  {{ current }}
  <span class="with-love">
    <i class="icon-heart"></i>
  </span>
  <span class="author">{{ config.author }}</span>
</div>

{% block footer %}{% endblock %}
